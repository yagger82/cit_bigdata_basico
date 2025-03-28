/* UNIVERSIDAD NACIONAL DE ASUNCION
 * Facultad Politécnica - Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data
 * 
 * SCRIPTS: DDL PARA CREAR VISTAS EN EL STAGE AREA.
 * 
 * Descripcion: Etapa de preparación de los datos.
 *
 * @autor: Prof. Richar D. Jiménez-R. <rjimenez@pol.una.py>
 * @creacion: Setiembre 10, 2024
 * @ultima_modificacion: Setiembre 10, 2024
 * @version: 1.0.0
 */


-- ###########################################################################
-- Preparación de tablas objetivos:
--   1-NIVEL
--   2-ENTIDAD
--   3-OEE
-- ###########################################################################

-- vw_nivel definition

-- drop view stage.vw_nivel;

-- select * from stage.vw_nivel;

-- select count(*) from stage.vw_nivel;

create or replace view stage.vw_nivel as
select distinct 
	nivel as codigo,
	descripcion_nivel as descripcion
from
	raw.raw_nomina_sfp
where
	nivel is not null
	and descripcion_nivel is not null
order by nivel;



--vw_entidad definition

-- drop view stage.vw_entidad;

-- select * from stage.vw_entidad;

-- select count(*) from stage.vw_entidad;

create or replace view stage.vw_entidad as
select distinct 
	nivel as nivel_codigo,
	entidad as codigo,
	descripcion_entidad as descripcion
from
	raw.raw_nomina_sfp
where
	nivel is not null
	and entidad is not null
	and descripcion_entidad is not null
order by nivel, entidad;



-- vw_oee definition

-- drop view stage.vw_oee;

-- select * from stage.vw_oee;

-- select count(*) from stage.vw_oee;

create or replace view stage.vw_oee as
select distinct 
	nivel as nivel_codigo,
	entidad as entidad_codigo,
	oee as codigo,
	descripcion_oee as descripcion
from
	raw.raw_nomina_sfp
where
	nivel is not null
	and entidad is not null
	and oee is not null
	and descripcion_oee is not null
order by nivel, entidad, oee;



-- ###########################################################################
-- Preparación de tablas objetivos:
--   4-PERSONA
-- ###########################################################################

-- vw_persona_auxiliar definition

-- drop view stage.vw_persona_auxiliar;

-- select * from stage.vw_persona_auxiliar;

-- select count(*) from stage.vw_persona_auxiliar;

create or replace view stage.vw_persona_auxiliar as
select
	documento,
	nombre,
	apellido,
	fecha_nacimiento,
	case
		when sexo = 'FEMENINO' then 'F'
		when sexo = 'MASCULINO' then 'M'
		else 'N'
	end sexo_codigo,
	case 
		when nacionalidad_ctrl between '1' and '9' then 'PY'
		when nacionalidad_ctrl = 'E' then 'EX'
		else 'ND'
	end as nacionalidad_codigo
from (
	select distinct
		documento,
		trim(nombres) as nombre,
		trim(apellidos) as apellido,
		trim(sexo) as sexo,
		fecha_nacimiento::date,
		substring(documento, 1, 1) as nacionalidad_ctrl
	from
		raw.raw_nomina_sfp
	where
		documento is not null
		and nombres is not null
		and apellidos is not null
		and sexo is not null
		and substring(documento, 1, 1) not in('A', 'V') -- no persona
	order by documento
) p;



-- vw_persona_discapacidad_auxiliar definition

-- drop view stage.vw_persona_discapacidad_auxiliar;

-- select * from stage.vw_persona_discapacidad_auxiliar;

-- select count(*) from stage.vw_persona_discapacidad_auxiliar;

create or replace view stage.vw_persona_discapacidad_auxiliar as
select
	documento,
	array_agg(tipo_discapacidad) as tipo_discapacidad,
	array_agg(discapacidad) as discapacidad 
from (
	select distinct
		documento,
		trim(tipo_discapacidad) as tipo_discapacidad,
		trim(discapacidad) as discapacidad
	from
		raw.raw_nomina_sfp
	where
		documento is not null
		and nombres is not null
		and apellidos is not null
		and sexo is not null
		and substring(documento, 1, 1) not in('A', 'V') -- no persona
	order by documento
) pd
group by documento;



-- vw_persona

-- drop view stage.vw_persona;

-- select * from stage.vw_persona;

-- select count(*) from stage.vw_persona;

create or replace view stage.vw_persona as
select
	p.documento,
	p.nombre,
	p.apellido,
	p.fecha_nacimiento,
	p.sexo_codigo,
	p.nacionalidad_codigo,
   case
	when cardinality(pd.tipo_discapacidad) > 1 then '-1'
	else
		case
			when pd.tipo_discapacidad[1] = 'MULTIPLE'    then '00'
            when pd.tipo_discapacidad[1] = 'FISICA'      then '01'
            when pd.tipo_discapacidad[1] = 'INTELECTUAL' then '02'
            when pd.tipo_discapacidad[1] = 'PSICOSOCIAL' then '03'
            when pd.tipo_discapacidad[1] = 'AUDITIVA'    then '04'
            when pd.tipo_discapacidad[1] = 'VISUAL'      then '05'
            when pd.tipo_discapacidad[1] is null         then '99'
            else '-1'
         end
   end tipo_discapacidad_codigo,
   case 
	when cardinality(pd.discapacidad) > 1 then false
	else
		case
			when pd.discapacidad[1] = 'SI' then true
			else false
		end
   end discapacidad
from stage.vw_persona_auxiliar p
join stage.vw_persona_discapacidad_auxiliar pd on pd.documento = p.documento
order by documento;



-- ###########################################################################
-- Preparación de tablas objetivos:
--   5-FUNCIONARIO
--   6-CARGO
--   7-PROFESION
--   8-FUNCIONARIO_PUESTO
-- ###########################################################################

-- vw_funcionario_puesto definition

-- drop view stage.vw_funcionario_puesto;

-- select * from stage.vw_funcionario_puesto;

-- select count(*) from stage.vw_funcionario_puesto;

create or replace view stage.vw_funcionario_puesto as
select distinct
	documento,
	nivel as nivel_codigo,
	entidad as entidad_codigo,
	oee as oee_codigo,
	trim(estado) as estado_codigo,
	upper(trim(trim('"' from coalesce(profesion, 'DESCONOCIDO')))) as profesion_descripcion,
	md5(upper(trim(trim('"' from coalesce(profesion, 'DESCONOCIDO'))))) as profesion_codigo,	
	upper(trim(trim('"' from coalesce(cargo, 'DESCONOCIDO')))) as cargo_descripcion,
	md5(upper(trim(trim('"' from coalesce(cargo, 'DESCONOCIDO'))))) as cargo_codigo,
	coalesce(anho_ingreso, 0) as anho_ingreso,
	upper(trim(funcion)) as funcion
from
	raw.raw_nomina_sfp
where
	documento is not null
	and nivel is not null
	and entidad is not null
	and oee is not null
	and substring(documento, 1, 1) not in('A', 'V') -- no  persona
order by documento, nivel, entidad, oee, anho_ingreso;



-- vw_funcionario definition

-- drop view stage.vw_funcionario;

-- select * from stage.vw_funcionario;

-- select count(*) from stage.vw_funcionario;

create or replace view stage.vw_funcionario as
select
	documento,
	nivel_codigo,
	entidad_codigo,
	oee_codigo
from stage.vw_funcionario_puesto
group by documento, nivel_codigo, entidad_codigo, oee_codigo
order by documento, nivel_codigo, entidad_codigo, oee_codigo;



-- vw_cargo definition

-- drop view stage.vw_cargo;

-- select * from stage.vw_cargo;

-- select count(*) from stage.vw_cargo;

create or replace view stage.vw_cargo as
select distinct
	cargo_codigo as codigo,
	cargo_descripcion as descripcion
from stage.vw_funcionario_puesto
order by cargo_descripcion;



-- vw_profesion definition

-- drop view stage.vw_profesion;

-- select * from stage.vw_profesion;

-- select count(*) from stage.vw_profesion;

create or replace view stage.vw_profesion as
select distinct
	profesion_codigo as codigo,
	profesion_descripcion as descripcion
from stage.vw_funcionario_puesto
order by profesion_descripcion;



-- ###########################################################################
-- Preparación de tablas objetivos:
--    9-REMUNERACION_CABECERA
--   10-REMUNERACION_DETALLE
-- ###########################################################################


-- vm_remuneracion_detalle definition

-- drop materialized view stage.vm_remuneracion_detalle;

-- select * from stage.vm_remuneracion_detalle;

-- select count(*) from stage.vm_remuneracion_detalle;

create materialized view stage.vm_remuneracion_detalle as
select
	anho,
	mes,
	documento,
	nivel as nivel_codigo,
	entidad as entidad_codigo,
	oee as oee_codigo,
	md5(upper(trim(trim('"' from coalesce(profesion, 'DESCONOCIDO'))))) as profesion_codigo,
	md5(upper(trim(trim('"' from coalesce(cargo, 'DESCONOCIDO'))))) as cargo_codigo,
	trim(estado) as estado_codigo,
	coalesce(anho_ingreso, 0) as anho_ingreso,
	coalesce(fuente_financiamiento, '-1')::char(2) as fuente_financiamiento_codigo,
	objeto_gasto::smallint,
	case when stage.isnumeric(linea) then linea::int4 else -1 end as linea,
	trim(categoria)::varchar(16) as categoria,
	coalesce(presupuestado, 0) as monto_haberes,
	coalesce(devengado, 0) as monto_devengado
from raw.raw_nomina_sfp
where
	documento is not null
	and nivel is not null
	and entidad is not null
	and oee is not null
	and substring(documento, 1, 1) not in('A', 'V') 
order by documento;



-- vm_remuneracion_cabecera definition

-- drop materialized view stage.vm_remuneracion_cabecera;

-- select * from stage.vm_remuneracion_cabecera;

-- select count(*) from stage.vm_remuneracion_cabecera;

create materialized view stage.vm_remuneracion_cabecera as
select
	tm.anho,
	tm.mes,
	tm.documento,
	tm.nivel_codigo,
	tm.entidad_codigo,
	tm.oee_codigo,
	tm.cargo_codigo,
	tm.profesion_codigo,
	tm.estado_codigo,
	tm.anho_ingreso,
	sum(tm.monto_haberes) as total_haberes,
	sum(tm.monto_devengado) as total_devengado
from (
	select
		anho,
		mes,
		documento,
		nivel as nivel_codigo,
		entidad as entidad_codigo,
		oee as oee_codigo,
		md5(upper(trim(trim('"' from coalesce(profesion, 'DESCONOCIDO'))))) as profesion_codigo,
		md5(upper(trim(trim('"' from coalesce(cargo, 'DESCONOCIDO'))))) as cargo_codigo,
		trim(estado) as estado_codigo,
		coalesce(anho_ingreso, 0) as anho_ingreso,
		coalesce(fuente_financiamiento, '-1')::char(2) as fuente_financiamiento_codigo,
		objeto_gasto::smallint,
		case when stage.isnumeric(linea) then linea::int4 else -1 end as linea,
		trim(categoria)::varchar(16) as categoria,
		coalesce(presupuestado, 0) as monto_haberes,
		coalesce(devengado, 0) as monto_devengado
	from raw.raw_nomina_sfp
	where
		documento is not null
		and nivel is not null
		and entidad is not null
		and oee is not null
		and substring(documento, 1, 1) not in('A', 'V') 
) tm
group by tm.anho,
	tm.mes,
	tm.documento,
	tm.nivel_codigo,
	tm.entidad_codigo,
	tm.oee_codigo,
	tm.cargo_codigo,
	tm.cargo_codigo,
	tm.profesion_codigo,
	tm.estado_codigo,
	tm.anho_ingreso
order by tm.documento;


/*
create materialized view stage.vm_remuneracion_cabecera as
select
	anho,
	mes,
	documento,
	nivel_codigo,
	entidad_codigo,
	oee_codigo,
	cargo_codigo,
	profesion_codigo,
	estado_codigo,
	anho_ingreso,
	sum(monto_haberes) as total_haberes,
	sum(monto_devengado) as total_devengado
from stage.vm_remuneracion_detalle
group by anho,
	mes,
	documento,
	nivel_codigo,
	entidad_codigo,
	oee_codigo,
	cargo_codigo,
	cargo_codigo,
	profesion_codigo,
	estado_codigo,
	anho_ingreso
order by documento;
*/