
drop table practica.persona cascade;
drop table practica.tipo_discapacidad cascade;
drop table practica.tipo_funcionario cascade;
drop table practica.sexo cascade;
drop table practica.nacionalidad cascade;
drop table practica.funcionario cascade;
drop table practica.oee cascade;
drop table practica.entidad cascade;
drop table practica.nivel cascade;


/*
 * Tabla: NIVEL
 * */
with nivel as (
	select distinct
		nivel, descripcion_nivel
	from nomina
	order by nivel
)
--select * from nivel;
select max(length(descripcion_nivel)) from nivel;


/*
 * Tabla: ENTIDAD
 * */
with entidad as (
	select distinct
		nivel, entidad, descripcion_entidad
	from nomina
	order by nivel, entidad
)
--select * from entidad;
select max(length(descripcion_entidad)) from entidad;


/*
 * Tabla: OEE
 * */
with oee as (
	select distinct
		nivel, entidad, oee, descripcion_oee
	from nomina
	order by nivel, entidad, oee
)
--select * from oee;
select max(length(descripcion_oee)) from oee;


/*
 * Tabla: PERSONA
 * */
with persona as (
	select distinct
		documento, nombres, apellidos, sexo, fecha_nacimiento,
		substring(documento, 1, 1) contr
	from nomina
	order by documento
)
--select * from persona;
--select count(*) from persona;
select contr, count(*) from persona group by contr order by contr;
--select * from persona where contr = 'A';
--select * from persona where contr = 'E';
--select * from persona where contr = 'V';
--select max(length(nombres)) nom_max, max(length(apellidos)) ape_max, max(length(sexo)) sex_max from persona;


/*
 * Tabla: TIPO_DISCAPACIDAD
 * */
with tipo_discapacidad as (
	select distinct
		discapacidad, tipo_discapacidad
	from nomina
	order by tipo_discapacidad
)
select * from tipo_discapacidad;


/*
 * Tabla: TIPO_FUNCIONARIO
 * */
with tipo_funcionario as (
	select distinct
		estado
	from nomina
	order by estado
)
select * from tipo_funcionario;



/*
 * Tabla: REMUNERACION
 * */
with pagos as (
	select distinct
		documento, nombres, apellidos, descripcion_oee, cargo, objeto_gasto, concepto, linea, categoria, presupuestado, devengado, 
		substring(documento, 1, 1) contr
	from nomina
	order by documento
)
--select * from pagos;
select * from pagos;

with resumen as (
	with pagos as (
		select distinct
			documento, nombres, apellidos, descripcion_oee, cargo, objeto_gasto, concepto, linea, categoria, presupuestado, devengado, 
			substring(documento, 1, 1) contr
		from nomina
		order by documento
	)
	select * from pagos where not contr in('A', 'V')
)
select documento, descripcion_oee, cargo, count(*) 
from resumen group by documento, descripcion_oee, cargo
having count(*) > 1
order by documento;





with resumen as (
	with pagos as (
		select distinct
			documento, nombres, apellidos, descripcion_oee, cargo, objeto_gasto, concepto, linea, categoria, presupuestado, devengado, 
			substring(documento, 1, 1) contr
		from nomina
		order by documento
	)
	select distinct documento, descripcion_oee, cargo from pagos where not contr in('A', 'V') order by documento
)
select * from resumen;



