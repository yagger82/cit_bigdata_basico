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
('99', 'CAPACIDAD', false, 'etlsystem'),
('-1', 'DESCONOCIDO', false, 'etlsystem');



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



-- DROP TABLE sfp.estado;

-- TRUNCATE TABLE sfp.sexo RESTART IDENTITY CASCADE;

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



-- DROP TABLE sfp.periodo;

-- TRUNCATE TABLE sfp.periodo RESTART IDENTITY CASCADE;

-- SELECT * FROM sfp.periodo;

insert into sfp.periodo (anho, mes, mes_descripcion, trimestre, cuatrimestre, semestre, usuario_creacion) values
(2013,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2013,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2013,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2013,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2013,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2013,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2013,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2013,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2013,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2013, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2013, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2013, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2014,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2014,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2014,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2014,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2014,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2014,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2014,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2014,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2014,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2014, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2014, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2014, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2015,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2015,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2015,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2015,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2015,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2015,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2015,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2015,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2015,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2015, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2015, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2015, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2016,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2016,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2016,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2016,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2016,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2016,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2016,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2016,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2016,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2016, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2016, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2016, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2017,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2017,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2017,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2017,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2017,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2017,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2017,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2017,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2017,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2017, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2017, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2017, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2018,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2018,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2018,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2018,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2018,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2018,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2018,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2018,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2018,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2018, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2018, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2018, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2019,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2019,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2019,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2019,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2019,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2019,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2019,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2019,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2019,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2019, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2019, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2019, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2020,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2020,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2020,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2020,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2020,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2020,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2020,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2020,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2020,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2020, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2020, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2020, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2021,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2021,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2021,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2021,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2021,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2021,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2021,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2021,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2021,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2021, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2021, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2021, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2022,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2022,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2022,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2022,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2022,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2022,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2022,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2022,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2022,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2022, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2022, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2022, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2023,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2023,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2023,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2023,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2023,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2023,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2023,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2023,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2023,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2023, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2023, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2023, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2024,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2024,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2024,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2024,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2024,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2024,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2024,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2024,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2024,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2024, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2024, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2024, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2025,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2025,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2025,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2025,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2025,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2025,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2025,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2025,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2025,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2025, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2025, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2025, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem'),
(2026,  1, 'ENERO',     '1', '1', '1', 'etlsystem'),
(2026,  2, 'FEBRERO',   '1', '1', '1', 'etlsystem'),
(2026,  3, 'MARZO',     '1', '1', '1', 'etlsystem'),
(2026,  4, 'ABRIL',     '2', '1', '1', 'etlsystem'),
(2026,  5, 'MAYO',      '2', '2', '1', 'etlsystem'),
(2026,  6, 'JUNIO',     '2', '2', '1', 'etlsystem'),
(2026,  7, 'JULIO',     '3', '2', '2', 'etlsystem'),
(2026,  8, 'AGOSTO',    '3', '2', '2', 'etlsystem'),
(2026,  9, 'SETIEMBRE', '3', '3', '2', 'etlsystem'),
(2026, 10, 'OCTUBRE',   '4', '3', '2', 'etlsystem'),
(2026, 11, 'NOVIEMBRE', '4', '3', '2', 'etlsystem'),
(2026, 12, 'DICIEMBRE', '4', '3', '2', 'etlsystem');
