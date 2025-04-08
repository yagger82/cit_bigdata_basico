
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
	periodo_mes_nombre TEXT,
	institucion_nivel_codigo TEXT,
	institucion_nivel_descripcion TEXT,
	institucion_entidad_codigo TEXT,
	institucion_entidad_descripcion TEXT,
	institucion_oee_codigo TEXT,
	institucion_oee_descripcion TEXT,
	funcionario_segmento TEXT,
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
	rubro_monto_presupuestado BIGINT,
	rubro_monto_devengado BIGINT
);

select * from dpl.rp_remuneraciones;