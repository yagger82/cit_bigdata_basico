select
	anho, 
	mes,
	nivel_codigo,
	entidad_codigo,
	oee_codigo,
	documento,
	nombres,
	apellidos,
	sexo,
	fecha_nacimiento,
	estado,
	anho_ingreso,
	linea,
	categoria,
	objeto_gasto_codigo,
	presupuestado,
	devengado
from stage.sfp_nomina_temporal
where not (presupuestado = 0 or presupuestado < devengado)
and (nivel_codigo is not null or entidad_codigo is not null or oee_codigo is not null);