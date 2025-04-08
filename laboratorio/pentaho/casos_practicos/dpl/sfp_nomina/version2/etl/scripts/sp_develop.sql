
select count(*) from stage.sfp_nomina_temporal; --2.785.413

--
SET lc_time = 'es_ES'; -- Configurar el idioma a español

select count(*) from tmp_rp_remuneraciones; --2.785.413

--

select count(*) from tmp_persona_discapacidad; --341.471

select documento, count(*) 
from tmp_persona_discapacidad
group by documento
having count(*) > 1;

--
truncate table dpl.rp_remuneraciones;

--PASO 1 -

--drop table if exists tmp_rp_remuneraciones;

create temporary table tmp_rp_remuneraciones as
select
	anho as periodo_anho,
	mes as periodo_mes,
	upper(to_char((anho||'-'||mes||'-01')::date, 'TMMonth')) as periodo_mes_nombre,
	nivel_codigo,
	entidad_codigo,
	oee_codigo,
	case
		when left(documento, 1) between '1' and '9' then 'NACIONAL'
		when left(documento, 1) = 'E' then 'EXTRANJERO'
		when left(documento, 1) = 'A' then 'ANONIMO'
		else 'DESCONOCIDO'
	end as funcionario_segmento,
	documento,
	upper(trim(nombres)) as funcionario_nombres,
	upper(trim(apellidos)) as funcionario_apellidos,
	upper(trim(sexo)) as funcionario_sexo,
	coalesce(fecha_nacimiento::date, '1900-01-01')::text as funcionario_fecha_nacimiento,
	upper(trim(estado)) as funcionario_estado,
	case 
		when anho_ingreso::integer between 1950 and extract(year from current_date) then anho_ingreso
		else case
				when split_part(fecha_acto, '/', 1)::integer between 1950 and extract(year from current_date)
	        	then split_part(fecha_acto, '/', 1)
	        	else '-1'
		end
	end as funcionario_anho_ingreso,
	coalesce(rtrim(linea), '-1') as rubro_linea,
	coalesce(rtrim(categoria), '-1') as rubro_categoria,
	objeto_gasto_codigo,
	presupuestado as rubro_monto_presupuestado,
	devengado as rubro_monto_devengado
from stage.sfp_nomina_temporal
where --eliminar registros no deseados 
	not (presupuestado = 0 or presupuestado < devengado)
	and (nivel_codigo is not null or entidad_codigo is not null or oee_codigo is not null)
order by documento, nivel_codigo, entidad_codigo, oee_codigo
;

CREATE INDEX idx_rp_remuneraciones_documento ON tmp_rp_remuneraciones (documento);
CREATE INDEX idx_rp_remuneraciones_objeto_gasto_codigo ON tmp_rp_remuneraciones (objeto_gasto_codigo);
CREATE INDEX idx_rp_remuneraciones_nivel_entidad_oee_codigo ON tmp_rp_remuneraciones (nivel_codigo, entidad_codigo, oee_codigo);



--PASO 2 -
--drop table if exists tmp_persona_discapacidad;
create temporary table tmp_persona_discapacidad as
select
	documento,
	case
		when cardinality(tipo_discapacidad) = 1 then coalesce(tipo_discapacidad[1], 'NINGUNO')
		when cardinality(tipo_discapacidad) = 2 then tipo_discapacidad[1]
		when cardinality(tipo_discapacidad) > 2 then 'MULTIPLE'
		else 'DESCONOCIDO'
	end funcionario_discapacidad_tipo,
	case
		when cardinality(discapacidad) = 1 then coalesce(discapacidad[1], 'NO')
		when cardinality(discapacidad) > 1 then 'SI'
		else 'NO'
	end funcionario_discapacidad	
from (
	select
		documento,
		array_agg(distinct tipo_discapacidad) as tipo_discapacidad,
		array_agg(distinct discapacidad) as discapacidad 
	from stage.sfp_nomina_temporal
	group by documento
) tt
order by documento;

CREATE INDEX idx_persona_discapacidad_documento ON tmp_persona_discapacidad (documento);



--PASO 3 -

--version 1
EXPLAIN ANALYZE
insert into dpl.rp_remuneraciones
select
    rem.periodo_anho,
    rem.periodo_mes,
    rem.periodo_mes_nombre,
    rem.nivel_codigo as institucion_nivel_codigo,
    sfp.nivel_descripcion as institucion_nivel_descripcion,
    rem.entidad_codigo as institucion_entidad_codigo,
    sfp.entidad_descripcion as institucion_entidad_descripcion,
    rem.oee_codigo as institucion_oee_codigo,
    sfp.oee_descripcion as institucion_oee_descripcion,
    rem.funcionario_segmento,
    rem.documento as funcionario_cedula,
    rem.funcionario_nombres,
    rem.funcionario_apellidos,
    rem.funcionario_sexo,
    rem.funcionario_fecha_nacimiento,
    per.funcionario_discapacidad,
	per.funcionario_discapacidad_tipo,
    rem.funcionario_estado,
    rem.funcionario_anho_ingreso,
    rem.rubro_linea,
    rem.rubro_categoria,
    rem.objeto_gasto_codigo as rubro_objeto_gasto_codigo,
    pgn.objeto_gasto_descripcion as rubro_objeto_gasto_concepto,
    rem.rubro_monto_presupuestado,
    rem.rubro_monto_devengado
from tmp_rp_remuneraciones rem  --PASO 1
join tmp_persona_discapacidad per on per.documento = rem.documento  --PASO 2
join ods.pgn_gastos_clasificador pgn on pgn.objeto_gasto_codigo = rem.objeto_gasto_codigo  --ODS
join ods.sfp_oee sfp on sfp.nivel_codigo = rem.nivel_codigo --ODS
	and sfp.entidad_codigo = rem.entidad_codigo and sfp.oee_codigo = rem.oee_codigo
order by rem.documento, rem.nivel_codigo, rem.entidad_codigo, rem.oee_codigo
;


---version-2: Estrategias de optimización

SET synchronous_commit TO OFF;
SET work_mem TO '128MB'; -- Ajusta según la memoria disponible.

SET enable_nestloop TO OFF;

truncate table dpl.rp_remuneraciones;

--EXPLAIN ANALYZE
WITH cte_remuneraciones AS (
    SELECT rem.*, per.funcionario_discapacidad, per.funcionario_discapacidad_tipo FROM tmp_rp_remuneraciones rem
    JOIN tmp_persona_discapacidad per ON per.documento = rem.documento
)
INSERT INTO dpl.rp_remuneraciones
select
    rem.periodo_anho,
    rem.periodo_mes,
    rem.periodo_mes_nombre,
    sfp.nivel_codigo as institucion_nivel_codigo,
    sfp.nivel_descripcion as institucion_nivel_descripcion,
    sfp.entidad_codigo as institucion_entidad_codigo,
    sfp.entidad_descripcion as institucion_entidad_descripcion,
    sfp.oee_codigo as institucion_oee_codigo,
    sfp.oee_descripcion as institucion_oee_descripcion,
    rem.funcionario_segmento,
    rem.documento as funcionario_cedula,
    rem.funcionario_nombres,
    rem.funcionario_apellidos,
    rem.funcionario_sexo,
    rem.funcionario_fecha_nacimiento,
    rem.funcionario_discapacidad,
	rem.funcionario_discapacidad_tipo,
    rem.funcionario_estado,
    rem.funcionario_anho_ingreso,
    rem.rubro_linea,
    rem.rubro_categoria,
    pgn.objeto_gasto_codigo as rubro_objeto_gasto_codigo,
    pgn.objeto_gasto_descripcion as rubro_objeto_gasto_concepto,
    rem.rubro_monto_presupuestado,
    rem.rubro_monto_devengado
FROM cte_remuneraciones rem
join ods.sfp_oee sfp on sfp.nivel_codigo = rem.nivel_codigo 
	and sfp.entidad_codigo = rem.entidad_codigo and sfp.oee_codigo = rem.oee_codigo
join ods.pgn_gastos_clasificador pgn on pgn.objeto_gasto_codigo = rem.objeto_gasto_codigo
;


