/* UNIVERSIDAD NACIONAL DE ASUNCION
 * Facultad Politécnica - Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data
 * 
 * SCRIPTS: DML PARA CREAR LOS REGISTROS DE LAS TABLAS PARAMETRICAS.
 * 
 * Descripción: Insertar registros en las tablas paramétricas.
 *
 * @autor: Prof. Richar D. Jiménez-R. <rjimenez@pol.una.py>
 * @creacion: Setiembre 10, 2024
 * @ultima_modificacion: Setiembre 10, 2024
 * @version: 1.0.0
 */


-- DROP TABLE sfp.periodo;

-- TRUNCATE TABLE sfp.periodo RESTART IDENTITY CASCADE;

-- SELECT * FROM sfp.periodo;

with periodo as (
select
    date_trunc('month', generate_series('2000-01-01'::date, '2030-12-31'::date, '1 month')) as fecha
)
insert into sfp.periodo (anho, mes, mes_nombre, trimestre, cuatrimestre, semestre, usuario_creacion)
select 
	extract(year from fecha) as anho,
	extract(month from fecha) as mes,
	upper(to_char(fecha, 'TMMonth')) as mes_nombre,
	TO_CHAR(fecha, 'q') AS trimestre,
	case
		when extract(month from fecha) between 1 and 4 then 1
		when extract(month from fecha) between 5 and 8 then 2
		when extract(month from fecha) between 9 and 12 then 3
	end as cuatrimestre,
	case
		when extract(month from fecha) between 1 and 6 then 1
		when extract(month from fecha) between 7 and 12 then 2
	end as semestre,
	'etlsystem' as usuario_creacion
from periodo;


-- DROP TABLE sfp.tipo_discapacidad;

-- TRUNCATE TABLE sfp.tipo_discapacidad RESTART IDENTITY CASCADE;

-- SELECT * FROM sfp.tipo_discapacidad;

insert into sfp.tipo_discapacidad (codigo, descripcion, discapacidad, usuario_creacion) values 
('00', 'MULTIPLE', true, 'etlsystem'),
('01', 'FISICA', true, 'etlsystem'),
('02', 'INTELECTUAL', true, 'etlsystem'),
('03', 'PSICOSOCIAL', true, 'etlsystem'),
('04', 'AUDITIVA', true, 'etlsystem'),
('05', 'VISUAL', true, 'etlsystem'),
('99', 'NINGUNA', false, 'etlsystem'),
('-1', 'DESCONOCIDO', false, 'etlsystem');


-- DROP TABLE sfp.estado;

-- TRUNCATE TABLE sfp.estado RESTART IDENTITY CASCADE;

-- SELECT * FROM sfp.estado;

insert into sfp.estado (codigo, descripcion, usuario_creacion) values
('COMISIONADO', 'PERSONAL TRASLADADO PARA PRESTAR SERVICIO TEMPORAL EN OTRO OEE', 'etlsystem'),
('CONTRATADO', 'FUNCIONARIO CONTRATADO POR TIEMPO DETERMINADO PRESTA SERVICIO AL ESTADO', 'etlsystem'),
('PERMANENTE', 'FUNCIONARIO NOMBRADO PARA OCUPAR DE MANERA PERMANENTE UN CARGO', 'etlsystem'),
('DESCONOCIDO', 'FUNCIONARIO NOMBRADO PARA OCUPAR DE MANERA PERMANENTE UN CARGO', 'etlsystem');


-- DROP TABLE sfp.fuente_financiamiento;

-- TRUNCATE TABLE sfp.fuente_financiamiento RESTART IDENTITY CASCADE;

-- SELECT * FROM sfp.fuente_financiamiento;

insert into sfp.fuente_financiamiento (codigo, descripcion, usuario_creacion) values
('10', 'TESORO PUBLICO', 'etlsystem'),
('20', 'PRESTAMOS', 'etlsystem'),
('30', 'GENERADOS POR LAS PROPIAS INSTITUCIONES', 'etlsystem'),
('-1', 'DESCONOCIDO', 'etlsystem');


-- DROP TABLE sfp.sexo;

-- TRUNCATE TABLE sfp.sexo RESTART IDENTITY CASCADE;

-- SELECT * FROM sfp.sexo;

insert into sfp.sexo (codigo, descripcion, usuario_creacion) values
('F', 'FEMENINO', 'etlsystem'),
('M', 'MASCULINO', 'etlsystem'),
('N', 'DESCONOCIDO', 'etlsystem');


-- DROP TABLE sfp.nacionalidad;

-- TRUNCATE TABLE sfp.nacionalidad RESTART IDENTITY CASCADE;

-- SELECT * FROM sfp.nacionalidad;

insert into sfp.nacionalidad (codigo, descripcion, usuario_creacion) values
('PY', 'PARAGUAYA', 'etlsystem'),
('EX', 'EXTRANJERA', 'etlsystem'),
('NA', 'NO APLICA', 'etlsystem'),
('ND', 'NO DEFINE', 'etlsystem');
