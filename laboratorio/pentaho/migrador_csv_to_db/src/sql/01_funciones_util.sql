/* UNIVERSIDAD NACIONAL DE ASUNCION
 * Facultad Politécnica - Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data
 * 
 * SCRIPTS: DDL PARA CREAR LA BASE DE DATOS DE LABORATORIO Y LOS ESQUEMAS DE LA CAPA DE DATOS.
 * 
 * Descripción: Crear la estructura de la base de datos inicial.
 *
 * @autor: Prof. Richar D. Jiménez-R. <rjimenez@pol.una.py>
 * @creacion: Setiembre 10, 2024
 * @ultima_modificacion: Setiembre 10, 2024
 * @version: 1.0.0
 */


-- Si la conversión es exitosa, la función devuelve verdadero (TRUE); de lo contrario, 
-- devuelve falso (FALSE). Esta función verifica si una cadena es numérico.
create or replace function stage.isnumeric(text) returns boolean as $$
declare
    x numeric;
begin
    x = $1::numeric;
    return true;
exception
    when others then
        return false;
end;
$$ strict language plpgsql immutable;



--crear la función de refresco
create or replace function stage.refrescar_vm_remuneracion_cabecera_detalle() returns trigger as $$
begin
	-- actualizar vistas en el orden correcto
	refresh materialized view stage.vm_remuneracion_detalle;

	refresh materialized view stage.vm_remuneracion_cabecera;

	return null;
end;
$$ language plpgsql;

--crear el trigger
create trigger actualizar_vm_remuneracion_cabecera_detalle
after insert or update or delete
on raw.raw_nomina_sfp
for each statement
execute function stage.refrescar_vm_remuneracion_cabecera_detalle();