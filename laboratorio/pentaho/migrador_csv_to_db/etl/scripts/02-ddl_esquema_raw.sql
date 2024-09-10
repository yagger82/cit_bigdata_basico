/* UNIVERSIDAD NACIONAL DE ASUNCION
 * Facultad Politécnica - Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data
 * 
 * SCRIPTS: DDL PARA CREAR TABLAS EN EL ESQUEMA RAW.
 * 
 * Descripción: Etapa de extracción de datos.
 *
 * @autor: Prof. Richar D. Jiménez-R. <rjimenez@pol.una.py>
 * @creacion: Setiembre 10, 2024
 * @ultima_modificacion: Setiembre 10, 2024
 * @version: 1.0.0
 */


-- raw.raw_sfp_nomina definition

-- DROP TABLE raw_sfp_nomina;

CREATE TABLE raw.raw_sfp_nomina (
	anho int2 NULL,
	mes int2 NULL,
	nivel int2 NULL,
	descripcion_nivel text NULL,
	entidad int2 NULL,
	descripcion_entidad text NULL,
	oee int2 NULL,
	descripcion_oee text NULL,
	documento text NULL,
	nombres text NULL,
	apellidos text NULL,
	sexo text NULL,
	fecha_nacimiento date NULL,
	discapacidad text NULL,
	tipo_discapacidad text NULL,
	profesion text NULL,
	anho_ingreso int2 NULL,
	cargo text NULL,
	funcion text NULL,
	estado text NULL,
	fuente_financiamiento int2 NULL,
	objeto_gasto int2 NULL,
	concepto text NULL,
	linea text NULL,
	categoria text NULL,
	presupuestado int4 NULL,
	devengado int4 NULL
);
