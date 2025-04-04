SET search_path TO repgi;


DROP TABLE IF EXISTS dpl.rp_remuneraciones;

/*
 * Corresponde a los datos de las remuneraciones presupuestadas y devengadas 
 * de los Funcionarios Públicos por cada entidad.
*/

-- tabla final para el reporte
CREATE TABLE dpl.rp_remuneraciones (
	periodo_anho TEXT,
	periodo_mes TEXT,
	nivel_codigo TEXT,
	nivel_descripcion TEXT,
	entidad_codigo TEXT,
	entidad_descripcion TEXT,
	oee_codigo TEXT,
	oee_descripcion TEXT,
	funcionario_cedula TEXT,
	funcionario_nombres TEXT,
	funcionario_apellidos TEXT,
	funcionario_sexo TEXT,
	funcionario_fecha_nacimiento TEXT,
	funcionario_discapacidad TEXT,
	funcionario_discapacidad_tipo TEXT,
	funcionario_estado TEXT,
	funcionario_anho_ingreso TEXT,
	rubro_linea_codigo TEXT,
	rubro_categoria_codigo TEXT,
	rubro_objeto_gasto_codigo TEXT ,
	rubro_objeto_gasto_concepto TEXT,
	monto_presupuestado BIGINT,
	monto_devengado BIGINT
);

select * from dpl.rp_remuneraciones;