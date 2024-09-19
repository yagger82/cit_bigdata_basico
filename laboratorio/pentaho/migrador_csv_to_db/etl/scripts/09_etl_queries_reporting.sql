/* UNIVERSIDAD NACIONAL DE ASUNCION
 * Facultad Politécnica - Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data
 * 
 * SCRIPTS: QUERIES PARA REPORTES DE MONITOREOS Y CONTROL DEL PROCESO DE ETL.
 * 
 * Descripción: Reportes Ad Hoc.
 *
 * @autor: Prof. Richar D. Jiménez-R. <rjimenez@pol.una.py>
 * @creacion: Setiembre 10, 2024
 * @ultima_modificacion: Setiembre 10, 2024
 * @version: 1.0.0
 */


/* CONTEO DE FILAS DE RAW
 */
select count(*) from raw.raw_sfp_nomina; 



/* CONTEO DE FILAS DE CADA VISTA
 */

-- drop view stage.rpt_vw_conteo_filas;

-- select * from stage.rpt_vw_conteo_filas;

create or replace view stage.rpt_vw_conteo_filas as
select
	tm.id,
	tm.vista,
	tm.cantidad
from (
	select 1 as id, 'VW_NIVEL' as vista, count(*) as cantidad from stage.vw_nivel
		union
	select 2 as id, 'VW_ENTIDAD' as vista, count(*) as cantidad from stage.vw_entidad
		union
	select 3 as id, 'VW_OEE' as vista, count(*) as cantidad from stage.vw_oee
		union
	select 4 as id, 'VW_PERSONA' as vista, count(*) as cantidad from stage.vw_persona
		union
	select 5 as id, 'VW_CARGO' as vista, count(*) as cantidad from stage.vw_cargo
		union
	select 6 as id, 'VW_PROFESION' as vista, count(*) as cantidad from stage.vw_profesion
		union
	select 7 as id, 'VW_FUNCIONARIO' as vista, count(*) as cantidad from stage.vw_funcionario
		union
	select 8 as id, 'VW_FUNCIONARIO_PUESTO' as vista, count(*) as cantidad from stage.vw_funcionario_puesto
		union
	select 9 as id, 'VW_REMUNERACION_CABECERA' as vista, count(*) as cantidad from stage.vw_remuneracion_cabecera
		union
	select 10 as id, 'VW_REMUNERACION_DETALLE' as vista, count(*) as cantidad from stage.vw_remuneracion_detalle
) tm
order by tm.id
;



/* CONTEO DE FILAS DE CADA TABLA DEL sfp
 */

-- drop view stage.rpt_vw_conteo_sfp;

-- select * from stage.rpt_vw_conteo_sfp;

create or replace view stage.rpt_vw_conteo_sfp as
select
	tm.id,
	tm.tabla,
	tm.cantidad,
	tm.parametrica
from (
	select 1 as id, 'tipo_discapacidad' tabla, count(*) cantidad, true as parametrica from sfp.tipo_discapacidad
	  	union
	select 2 as id, 'sexo' tabla, count(*) cantidad, true as parametrica from sfp.sexo
	  	union
	select 3 as id, 'nacionalidad' tabla, count(*) cantidad, true as parametrica from sfp.nacionalidad
	  	union
	select 4 as id, 'estado' tabla, count(*) cantidad, true as parametrica from sfp.estado
	  	union
	select 5 as id, 'fuente_financiamiento' tabla, count(*) cantidad, true as parametrica from sfp.fuente_financiamiento
	  	union
	select 6 as id, 'periodo' tabla, count(*) cantidad, true as parametrica from sfp.periodo
	  	union
	select 7 as id, 'control_financiero' tabla, count(*) cantidad, true as parametrica from sfp.control_financiero
	  	union
	select 8 as id, 'grupo_gasto' tabla, count(*) cantidad, true as parametrica from sfp.grupo_gasto
	  	union
	select 9 as id, 'subgrupo_gasto' tabla, count(*) cantidad, true as parametrica from sfp.subgrupo_gasto
	  	union
	select 10 as id, 'objeto_gasto' tabla, count(*) cantidad, true as parametrica from sfp.objeto_gasto
		union
	select 11 as id, 'nivel' tabla, count(*) cantidad, false as parametrica from sfp.nivel
		union
	select 12 as id, 'entidad' tabla, count(*) cantidad, false as parametrica from sfp.entidad
		union
	select 13 as id, 'oee' tabla, count(*) cantidad, false as parametrica from sfp.oee
		union
	select 14 as id, 'persona' tabla, count(*) cantidad, false as parametrica from sfp.persona
		union
	select 15 as id, 'funcionario' tabla, count(*) cantidad, false as parametrica from sfp.funcionario
		union
	select 16 as id, 'cargo' tabla, count(*) cantidad, false as parametrica from sfp.cargo
		union
	select 17 as id, 'profesion' tabla, count(*) cantidad, false as parametrica from sfp.profesion
		union
	select 18 as id, 'funcionario_puesto' tabla, count(*) cantidad, false as parametrica from sfp.funcionario_puesto
		union
	select 19 as id, 'remuneracion_cabecera' tabla, count(*) cantidad, false as parametrica from sfp.remuneracion_cabecera
		union
	select 20 as id, 'remuneracion_detalle' tabla, count(*) cantidad, false as parametrica from sfp.remuneracion_detalle
) tm
order by tm.id;