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
CREATE OR REPLACE FUNCTION stage.isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE
    x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION
    WHEN others THEN
        RETURN FALSE;
END;
$$ STRICT LANGUAGE plpgsql IMMUTABLE;
