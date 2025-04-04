create temporary table mydata as
-- revision de totales de registros
select count(*) from stage.sfp_nomina_temporal; --1.883.346

-- revision: ANHO y MES
select anho, mes, count(*) from stage.sfp_nomina_temporal group by anho, mes;


-- revision de montos: PRESUPUESTADO y DEVENGADO
select count(*) from stage.sfp_nomina_temporal where presupuestado = 0; --0
select count(*) from stage.sfp_nomina_temporal where devengado = 0; --27.169

select count(*) from stage.sfp_nomina_temporal where presupuestado < devengado; --0
select count(*) from stage.sfp_nomina_temporal where presupuestado > devengado; --666.095
select count(*) from stage.sfp_nomina_temporal where presupuestado = devengado; --1.217.251

select 666095 + 1217251; --1.883.346


--- revision: NIVEL, ENTIDAD y OEE
select distinct nivel_codigo from stage.sfp_nomina_temporal where not nivel_codigo is null;
select distinct entidad_codigo from stage.sfp_nomina_temporal where not entidad_codigo is null;
select distinct oee_codigo from stage.sfp_nomina_temporal where not oee_codigo is null;

select nivel_codigo, entidad_codigo, oee_codigo, count(*)
from stage.sfp_nomina_temporal
where nivel_codigo is null or entidad_codigo is null or oee_codigo is null
group by nivel_codigo, entidad_codigo, oee_codigo;


-- revision: ESTADO
select estado, count(*) from stage.sfp_nomina_temporal group by estado; -- COMISIONADO | CONTRATADO | PERMANENTE

-- revision: DOCUMENTO
select left(documento, 1), count(*) --A: 219.919 V: 21.644 E: 182
from stage.sfp_nomina_temporal
group by left(documento, 1);

-- revision: NOMBRES, APELLIDOS, SEXO, FECHA_NACIMIENTO

select distinct sexo from stage.sfp_nomina_temporal; -- FEMENINO y MASCULINO

drop table temp_mydata;
create temporary table temp_mydata as
select documento, nombres, apellidos, sexo, fecha_nacimiento, presupuestado, devengado, objeto_gasto_codigo, estado
from stage.sfp_nomina_temporal
where left(documento, 1) = 'A';

select * from temp_mydata;

select distinct nombres from temp_mydata; --NOMBRES DEL FUNCIONARIO
select distinct apellidos from temp_mydata; --APELLIDOS DEL FUNCIONARIO
select distinct sexo from temp_mydata; -- MASCULINO y FEMENINO

select count(*) from temp_mydata where devengado = 0; --13
select * from temp_mydata where devengado = 0;

-- regla para eliminar registros ANONIMOS
select count(*) from stage.sfp_nomina_temporal where left(documento, 1) = 'A' and devengado = 0; --13

select count(*) from stage.sfp_nomina_temporal where not (left(documento, 1) = 'A' and devengado = 0); --1.883.333

--regla para eliminar registros VACANTES
select count(*) from stage.sfp_nomina_temporal where left(documento, 1) = 'V' and devengado > 0;


-- revision: FECHA_NACIMIENTO
select min(fecha_nacimiento::date), max(fecha_nacimiento::date)
from stage.sfp_nomina_temporal
where not (left(documento, 1) = 'A' and devengado = 0)
and not left(documento, 1) = 'V'
and not fecha_nacimiento::date = '1777-07-07'::date
;

select * from stage.sfp_nomina_temporal where fecha_nacimiento::date = '1777-07-07'::date;
select * from stage.sfp_nomina_temporal where fecha_nacimiento::date = '2011-08-23'::date;

select * from stage.sfp_nomina_temporal where fecha_nacimiento::date < '1930-01-01'::date;

select distinct extract(year from fecha_nacimiento::date) as anho 
from stage.sfp_nomina_temporal
order by anho asc;

select count(*) from stage.sfp_nomina_temporal where extract(year from fecha_nacimiento::date) is null;
select count(*) from stage.sfp_nomina_temporal where fecha_nacimiento::date is null; --21.822
select * from stage.sfp_nomina_temporal where fecha_nacimiento::date is null;
