-- ============================================================
-- 04. 20 CONSULTAS DE ANÁLISIS
-- ============================================================
USE universidad;

-- 01. Promedio final por asignatura.
SELECT asignatura, ROUND(AVG(nota_final),2) AS promedio
FROM historial_calificaciones
GROUP BY asignatura
ORDER BY promedio DESC;

-- 02. Cantidad de estudiantes evaluados por asignatura.
SELECT asignatura, COUNT(*) AS estudiantes_evaluados
FROM historial_calificaciones
GROUP BY asignatura
ORDER BY estudiantes_evaluados DESC;

-- 03. Cantidad de aprobados y reprobados.
SELECT estado, COUNT(*) AS cantidad
FROM historial_calificaciones
GROUP BY estado;

-- 04. Promedio final por alumno.
SELECT alumno, ROUND(AVG(nota_final),2) AS promedio_final
FROM historial_calificaciones
GROUP BY alumno
ORDER BY promedio_final DESC;

-- 05. Promedio por tipo de asignatura.
SELECT a.tipo, ROUND(AVG(h.nota_final),2) AS promedio
FROM historial_calificaciones h
JOIN asignatura a ON a.id=h.id_asignatura
GROUP BY a.tipo
ORDER BY promedio DESC;

-- 06. Promedio por curso escolar.
SELECT
    CONCAT(ce.anyo_inicio,'-',ce.anyo_fin) AS curso,
    ROUND(AVG(h.nota_final),2) AS promedio
FROM historial_calificaciones h
JOIN curso_escolar ce ON ce.id=h.id_curso_escolar
GROUP BY ce.id, ce.anyo_inicio, ce.anyo_fin
ORDER BY ce.anyo_inicio;

-- 07. Nota máxima por asignatura.
SELECT asignatura, MAX(nota_final) AS nota_maxima
FROM historial_calificaciones
GROUP BY asignatura
ORDER BY nota_maxima DESC;

-- 08. Nota mínima por asignatura.
SELECT asignatura, MIN(nota_final) AS nota_minima
FROM historial_calificaciones
GROUP BY asignatura
ORDER BY nota_minima;

-- 09. Asignaturas con promedio superior o igual a 3.
SELECT asignatura, ROUND(AVG(nota_final),2) AS promedio
FROM historial_calificaciones
GROUP BY asignatura
HAVING AVG(nota_final) >= 3
ORDER BY promedio DESC;

-- 10. Alumnos con promedio final superior o igual a 4.
SELECT alumno, ROUND(AVG(nota_final),2) AS promedio
FROM historial_calificaciones
GROUP BY alumno
HAVING AVG(nota_final) >= 4
ORDER BY promedio DESC;

-- 11. Total de créditos matriculados por alumno.
SELECT
    CONCAT(p.nombre,' ',p.apellido1) AS alumno,
    SUM(a.creditos) AS total_creditos
FROM alumno_se_matricula_asignatura m
JOIN persona p ON p.id=m.id_alumno
JOIN asignatura a ON a.id=m.id_asignatura
GROUP BY m.id_alumno, p.nombre, p.apellido1
ORDER BY total_creditos DESC;

-- 12. Comparación entre estudiantes con y sin trabajo práctico.
SELECT
    CASE
        WHEN trabajo_practico IS NULL THEN 'Sin trabajo práctico'
        ELSE 'Con trabajo práctico'
    END AS modalidad,
    COUNT(*) AS cantidad,
    ROUND(AVG(nota_final),2) AS promedio
FROM historial_calificaciones
GROUP BY modalidad;

-- 13. Promedio de cada componente.
SELECT
    ROUND(AVG(primer_parcial),2) AS promedio_primer_parcial,
    ROUND(AVG(segundo_parcial),2) AS promedio_segundo_parcial,
    ROUND(AVG(parcial_final),2) AS promedio_parcial_final,
    ROUND(AVG(trabajo_practico),2) AS promedio_trabajo_practico
FROM calificaciones;

-- 14. Distribución por estado académico.
SELECT
    estado,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM historial_calificaciones),2) AS porcentaje
FROM historial_calificaciones
GROUP BY estado;

-- 15. Estudiantes con más de una asignatura evaluada.
SELECT alumno, COUNT(*) AS asignaturas_evaluadas
FROM historial_calificaciones
GROUP BY alumno
HAVING COUNT(*) > 1
ORDER BY asignaturas_evaluadas DESC;

-- 16. Asignaturas con más de dos estudiantes evaluados.
SELECT asignatura, COUNT(*) AS cantidad
FROM historial_calificaciones
GROUP BY asignatura
HAVING COUNT(*) > 2
ORDER BY cantidad DESC;

-- 17. Consolidado general de calificaciones.
SELECT
    COUNT(*) AS total_registros,
    ROUND(AVG(nota_final),2) AS promedio_general,
    MAX(nota_final) AS maxima,
    MIN(nota_final) AS minima
FROM historial_calificaciones;

-- 18. Clasificación académica mediante CASE.
SELECT
    alumno,
    asignatura,
    nota_final,
    CASE
        WHEN nota_final >= 4.5 THEN 'Excelente'
        WHEN nota_final >= 4.0 THEN 'Muy bueno'
        WHEN nota_final >= 3.0 THEN 'Aprobado'
        ELSE 'Reprobado'
    END AS clasificacion
FROM historial_calificaciones
ORDER BY nota_final DESC;

-- 19. Promedio de calificaciones con y sin trabajo práctico.
SELECT
    CASE
        WHEN trabajo_practico IS NULL THEN 'Sin trabajo práctico'
        ELSE 'Con trabajo práctico'
    END AS tipo_evaluacion,
    ROUND(AVG(nota_final),2) AS promedio_final
FROM historial_calificaciones
GROUP BY tipo_evaluacion;

-- 20. Ranking de alumnos por promedio final.
SELECT
    alumno,
    ROUND(AVG(nota_final),2) AS promedio_final,
    CASE
        WHEN AVG(nota_final) >= 4.5 THEN 'Excelente'
        WHEN AVG(nota_final) >= 4.0 THEN 'Muy bueno'
        WHEN AVG(nota_final) >= 3.0 THEN 'Aprobado'
        ELSE 'Reprobado'
    END AS estado
FROM historial_calificaciones
GROUP BY alumno
ORDER BY promedio_final DESC;
