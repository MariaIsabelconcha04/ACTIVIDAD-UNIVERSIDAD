-- ============================================================
-- 01. REDISEÑO Y CREACIÓN DE CALIFICACIONES
-- Ejecutar después de universidad.sql
-- ============================================================
USE universidad;

DROP VIEW IF EXISTS historial_calificaciones;
DROP TABLE IF EXISTS calificaciones;

CREATE TABLE calificaciones (
    id_calificacion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT UNSIGNED NOT NULL,
    id_asignatura INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    primer_parcial DECIMAL(3,2) NOT NULL,
    segundo_parcial DECIMAL(3,2) NOT NULL,
    parcial_final DECIMAL(3,2) NOT NULL,
    trabajo_practico DECIMAL(3,2) NULL,

    CONSTRAINT uq_calificacion_matricula
        UNIQUE (id_alumno, id_asignatura, id_curso_escolar),

    CONSTRAINT chk_primer_parcial
        CHECK (primer_parcial BETWEEN 0 AND 5),

    CONSTRAINT chk_segundo_parcial
        CHECK (segundo_parcial BETWEEN 0 AND 5),

    CONSTRAINT chk_parcial_final
        CHECK (parcial_final BETWEEN 0 AND 5),

    CONSTRAINT chk_trabajo_practico
        CHECK (trabajo_practico IS NULL OR trabajo_practico BETWEEN 0 AND 5),

    CONSTRAINT fk_calificacion_matricula
        FOREIGN KEY (id_alumno, id_asignatura, id_curso_escolar)
        REFERENCES alumno_se_matricula_asignatura(id_alumno, id_asignatura, id_curso_escolar)
) ENGINE=InnoDB;

CREATE OR REPLACE VIEW historial_calificaciones AS
SELECT
    c.id_calificacion,
    c.id_alumno,
    CONCAT(p.nombre, ' ', p.apellido1, ' ', COALESCE(p.apellido2,'')) AS alumno,
    c.id_asignatura,
    asig.nombre AS asignatura,
    c.id_curso_escolar,
    c.primer_parcial,
    c.segundo_parcial,
    c.parcial_final,
    c.trabajo_practico,
    ROUND(
        CASE
            WHEN c.trabajo_practico IS NULL THEN
                c.primer_parcial*0.20 +
                c.segundo_parcial*0.35 +
                c.parcial_final*0.45
            ELSE
                c.primer_parcial*0.20 +
                c.segundo_parcial*0.35 +
                c.parcial_final*0.35 +
                c.trabajo_practico*0.10
        END, 2
    ) AS nota_final,
    CASE
        WHEN (
            CASE
                WHEN c.trabajo_practico IS NULL THEN
                    c.primer_parcial*0.20 + c.segundo_parcial*0.35 + c.parcial_final*0.45
                ELSE
                    c.primer_parcial*0.20 + c.segundo_parcial*0.35 +
                    c.parcial_final*0.35 + c.trabajo_practico*0.10
            END
        ) >= 3.0 THEN 'APROBADO'
        ELSE 'REPROBADO'
    END AS estado
FROM calificaciones c
JOIN alumno a ON a.id_alumno = c.id_alumno
JOIN persona p ON p.id = a.id_alumno
JOIN asignatura asig ON asig.id = c.id_asignatura;
