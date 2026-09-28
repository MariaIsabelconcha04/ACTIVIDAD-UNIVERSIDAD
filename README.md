# ACTIVIDAD-UNIVERSIDAD

Actividad práctica de rediseño de una base de datos universitaria en MySQL Workbench.

## Contenido

La actividad está organizada en los archivos:

1. `universidad.sql` - crea la base de datos `universidad` y las 10 tablas.
2. `01_rediseño_calificaciones.sql` - crea la tabla `calificaciones`, restricciones CHECK y la vista `historial_calificaciones`.
3. `02_datos_prueba.sql` - inserta datos de departamentos, personas, profesores, alumnos, grados, cursos, asignaturas, matrículas y calificaciones.
4. `03_consultas_validacion.sql` - contiene 20 consultas de validación.
5. `04_consultas_analisis.sql` - contiene 20 consultas de análisis.
6. `Actividad_Completa_MySQLL.sql` - referencia el orden completo de ejecución.

## Orden recomendado en MySQL Workbench

Ejecutar primero:

`universidad.sql`

Luego:

`02_datos_prueba.sql`

Después:

`03_consultas_validacion.sql`

Y finalmente:

`04_consultas_analisis.sql`

La tabla `calificaciones` controla las notas entre 0 y 5. El trabajo práctico es opcional y acepta `NULL`.

## Ponderación

### Sin trabajo práctico
- Primer parcial: 20 %
- Segundo parcial: 35 %
- Parcial final: 45 %

### Con trabajo práctico
- Primer parcial: 20 %
- Segundo parcial: 35 %
- Parcial final: 35 %
- Trabajo práctico: 10 %

La nota final se calcula mediante `CASE` y queda disponible en la vista `historial_calificaciones`.
