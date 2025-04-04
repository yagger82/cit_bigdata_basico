with mydata as (
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
			ods.ods_sfp_nomina
		where
			documento is not null
			and nombres is not null
			and apellidos is not null
			and sexo is not null
			and substring(documento, 1, 1) not in('A', 'V') -- no persona
		order by documento
	) pd
	--where discapacidad = 'SI' and array_length(tipo_discapacidad) > 1
	group by documento
)
select * from mydata where cardinality(tipo_discapacidad) > 2;


SELECT array_length(ARRAY[1, 2, 3, 4], 1); -- Resultado: 4