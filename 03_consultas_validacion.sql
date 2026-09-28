-- ============================================================
-- 03. 20 CONSULTAS DE VALIDACIÓN
-- ============================================================
USE universidad;

-- 01. Matrículas con sus calificaciones.
SELECT * FROM historial_calificaciones ORDER BY alumno, asignatura;

-- 02. Alumnos que todavía no tienen calificación.
SELECT
    m.id_alumno,
    CONCAT(p.nombre,' ',p.apellido1) AS alumno,
    m.id_asignatura,
    a.nombre AS asignatura
FROM alumno_se_matricula_asignatura m
JOIN persona p ON p.id = m.id_alumno
JOIN asignatura a ON a.id = m.id_asignatura
LEFT JOIN calificaciones c
    ON c.id_alumno=m.id_alumno
   AND c.id_asignatura=m.id_asignatura
   AND c.id_curso_escolar=m.id_curso_escolar
WHERE c.id_calificacion IS NULL;

-- 03. Validar que toda calificación corresponde a una matrícula.
SELECT c.*
FROM calificaciones c
LEFT JOIN alumno_se_matricula_asignatura m
  ON m.id_alumno=c.id_alumno
 AND m.id_asignatura=c.id_asignatura
 AND m.id_curso_escolar=c.id_curso_escolar
WHERE m.id_alumno IS NULL;

-- 04. Calificaciones con trabajo práctico.
SELECT * FROM calificaciones
WHERE trabajo_practico IS NOT NULL;

-- 05. Calificaciones sin trabajo práctico.
SELECT * FROM calificaciones
WHERE trabajo_practico IS NULL;

-- 06. Alumnos con al menos una nota reprobatoria.
SELECT DISTINCT
    c.id_alumno,
    CONCAT(p.nombre,' ',p.apellido1) AS alumno
FROM calificaciones c
JOIN persona p ON p.id=c.id_alumno
WHERE c.primer_parcial < 3
   OR c.segundo_parcial < 3
   OR c.parcial_final < 3
   OR (c.trabajo_practico IS NOT NULL AND c.trabajo_practico < 3);

-- 07. Promedio del primer parcial.
SELECT ROUND(AVG(primer_parcial),2) AS promedio_primer_parcial
FROM calificaciones;

-- 08. Promedio del segundo parcial.
SELECT ROUND(AVG(segundo_parcial),2) AS promedio_segundo_parcial
FROM calificaciones;

-- 09. Promedio del parcial final.
SELECT ROUND(AVG(parcial_final),2) AS promedio_parcial_final
FROM calificaciones;

-- 10. Cantidad de calificaciones registradas.
SELECT COUNT(*) AS total_calificaciones
FROM calificaciones;

-- 11. Calificaciones con nota final calculada.
SELECT * FROM historial_calificaciones;

-- 12. Estado académico.
SELECT alumno, asignatura, nota_final, estado
FROM historial_calificaciones
ORDER BY alumno;

-- 13. Nota máxima final.
SELECT MAX(nota_final) AS nota_maxima
FROM historial_calificaciones;

-- 14. Nota mínima final.
SELECT MIN(nota_final) AS nota_minima
FROM historial_calificaciones;

-- 15. Promedio general final.
SELECT ROUND(AVG(nota_final),2) AS promedio_general
FROM historial_calificaciones;

-- 16. Registros que contienen NULL en trabajo práctico.
SELECT *
FROM calificaciones
WHERE trabajo_practico IS NULL;

-- 17. Registros con trabajo práctico.
SELECT *
FROM calificaciones
WHERE trabajo_practico IS NOT NULL;

-- 18. Validar rango de notas almacenadas.
SELECT *
FROM calificaciones
WHERE primer_parcial NOT BETWEEN 0 AND 5
   OR segundo_parcial NOT BETWEEN 0 AND 5
   OR parcial_final NOT BETWEEN 0 AND 5
   OR (trabajo_practico IS NOT NULL AND trabajo_practico NOT BETWEEN 0 AND 5);

-- 19. Consultar la definición de la vista.
SHOW CREATE VIEW historial_calificaciones;

-- 20. Verificar tablas del esquema.
SHOW TABLES;
