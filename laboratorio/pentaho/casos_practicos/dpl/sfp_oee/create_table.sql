
-- comando para eliminar tabla
DROP TABLE IF EXISTS ods.sfp_oee;

-- comando para crear tabla
CREATE TABLE ods.sfp_oee (
	nivel_codigo TEXT,
	nivel_descripcion TEXT,
	entidad_codigo TEXT,
	entidad_descripcion TEXT,
	oee_codigo TEXT,
	oee_descripcion TEXT,
	descripcion_corta TEXT
);

-- consultar tabla
SELECT * FROM ods.sfp_oee;