

select * from stage.sfp_nomina_temporal limit 20;

SET lc_time = 'es_ES'; -- Configurar el idioma a español
SELECT TO_CHAR(CURRENT_DATE, 'TMMonth') AS nombre_del_mes;



select
	anho	as periodo_anho, 
	mes		as periodo_mes,
	TO_CHAR((anho||'-'||mes||'-01')::date, 'TMMonth')	as periodo_mes_nombre,
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
where --eliminar registros no deseados 
	not (presupuestado = 0 or presupuestado < devengado)
	and (nivel_codigo is not null or entidad_codigo is not null or oee_codigo is not null)
limit 100;