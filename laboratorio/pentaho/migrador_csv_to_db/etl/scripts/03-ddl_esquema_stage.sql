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
-- Tablas objetivos:
--   1-NIVEL
--   2-ENTIDAD
--   3-OEE
-- ###########################################################################

-- drop view stage.vw_nivel;

-- select * from stage.vw_nivel;
-- select count(*) from stage.vw_nivel;

create or replace view stage.vw_nivel as
select distinct 
	nivel as codigo,
	descripcion_nivel as descripcion
from
	raw.raw_sfp_nomina
where
	nivel is not null
	and descripcion_nivel is not null
order by nivel;


-- drop view stage.vw_entidad;

-- select * from stage.vw_entidad;
-- select count(*) from stage.vw_entidad;

create or replace view stage.vw_entidad as
select distinct 
	nivel as nivel_codigo,
	entidad as codigo,
	descripcion_entidad as descripcion
from
	raw.raw_sfp_nomina
where
	nivel is not null
	and entidad is not null
	and descripcion_entidad is not null
order by nivel, entidad;


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
	raw.raw_sfp_nomina
where
	nivel is not null
	and entidad is not null
	and oee is not null
	and descripcion_oee is not null
order by nivel, entidad, oee;



-- ###########################################################################
-- Tabla objetivo:
--   4-PERSONA
-- ###########################################################################

-- drop view stage.vw_auxiliar_persona;

-- select * from stage.vw_auxiliar_persona;
-- select count(*) from stage.vw_auxiliar_persona;

create or replace view stage.vw_auxiliar_persona as
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
		raw.raw_sfp_nomina
	where
		documento is not null
		and nombres is not null
		and apellidos is not null
		and sexo is not null
		and fecha_nacimiento is not null
		and substring(documento, 1, 1) not in('A', 'V')
	order by documento
) p;


-- drop view stage.vw_auxiliar_persona_discapacidad;

-- select * from stage.vw_auxiliar_persona_discapacidad;

create or replace view stage.vw_auxiliar_persona_discapacidad as
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
		raw.raw_sfp_nomina
	where
		documento is not null
		and nombres is not null
		and apellidos is not null
		and sexo is not null
		and fecha_nacimiento is not null
		and substring(documento, 1, 1) not in('A', 'V')
	order by documento
) pd
group by documento;


-- drop view stage.vw_persona;

-- select * from stage.vw_persona;

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
from stage.vw_auxiliar_persona p
join stage.vw_auxiliar_persona_discapacidad pd on pd.documento = p.documento
order by documento;



-- ###########################################################################
-- Tablas objetivos:
--   5-FUNCIONARIO
--   6-CARGO
--   7-PROFESION
--   8-FUNCIONARIO_PUESTO
-- ###########################################################################

-- drop view stage.vw_funcionario_puesto

-- select * from stage.vw_funcionario_puesto;

create or replace view stage.vw_funcionario_puesto as
select distinct
	documento,
	nivel as nivel_codigo,
	entidad as entidad_codigo,
	oee as oee_codigo,
	trim(estado) as estado_codigo,
	trim(trim('"' from cargo)) as cargo_descripcion,
	md5(trim(trim('"' from cargo))) as cargo_codigo,
	trim(trim('"' from profesion)) as profesion_descripcion,
	md5(trim(trim('"' from profesion))) as profesion_codigo,
	anho_ingreso,
	trim(funcion) as funcion
from
	raw.raw_sfp_nomina
where
	documento is not null
	and nivel is not null
	and entidad is not null
	and oee is not null
	and estado is not null
	and cargo is not null
	and profesion is not null
	and substring(documento, 1, 1) not in('A', 'V') 
order by documento;


-- drop view stage.vw_funcionario

-- select * from stage.vw_funcionario;

create or replace view stage.vw_funcionario as
select distinct
	documento,
	nivel_codigo,
	entidad_codigo,
	oee_codigo,
	estado_codigo
from stage.vw_funcionario_puesto 
order by documento, nivel_codigo, entidad_codigo, oee_codigo;


-- drop view stage.vw_cargo

-- select * from stage.vw_cargo;

create or replace view stage.vw_cargo as
select distinct
	cargo_codigo as codigo,
	cargo_descripcion as descripcion
from stage.vw_funcionario_puesto
order by cargo_codigo;


-- drop view stage.vw_profesion

-- select * from stage.vw_profesion;

create or replace view stage.vw_profesion as
select distinct
	profesion_codigo as codigo,
	profesion_descripcion as descripcion
from stage.vw_funcionario_puesto
order by profesion_codigo;



-- ###########################################################################
-- Tablas objetivos:
--    9-REMUNERACION_CABECERA
--   10-REMUNERACION_DETALLE
-- ###########################################################################


-- drop view stage.vw_remuneracion_detalle

-- select * from stage.vw_remuneracion_detalle;

create or replace view stage.vw_remuneracion_detalle as
select distinct
	anho,
	mes,
	documento,
	nivel as nivel_codigo,
	entidad as entidad_codigo,
	oee as oee_codigo,
	md5(trim(trim('"' from cargo))) as cargo_codigo,
	md5(trim(trim('"' from profesion))) as profesion_codigo,
	cargo,
	profesion,
	anho_ingreso,
	coalesce(fuente_financiamiento, '-1')::char(2) as fuente_financiamiento_codigo,
	objeto_gasto,
	linea,
	categoria,
	presupuestado,
	devengado
from raw.raw_sfp_nomina
where
	documento is not null
	and nivel is not null
	and entidad is not null
	and oee is not null
	and cargo is not null
	and profesion is not null
	and substring(documento, 1, 1) not in('A', 'V') 
order by documento;


-- drop view stage.vw_remuneracion_cabecera

-- select * from stage.vw_remuneracion_cabecera;

create or replace view stage.vw_remuneracion_cabecera as
select
	anho,
	mes,
	documento,
	nivel_codigo,
	entidad_codigo,
	oee_codigo,
	cargo_codigo,
	profesion_codigo,
	anho_ingreso,
	sum(coalesce(presupuestado, 0)) as total_haberes,
	sum(coalesce(devengado, 0)) as total_devengado,
	sum(coalesce(presupuestado, 0) - coalesce(devengado, 0)) as total_descuentos
from stage.vw_remuneracion_detalle
group by anho,
	mes,
	documento,
	nivel_codigo,
	entidad_codigo,
	oee_codigo,
	cargo_codigo,
	cargo_codigo,
	profesion_codigo,
	anho_ingreso
order by documento;
