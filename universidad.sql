-- ============================================================
-- BASE DE DATOS UNIVERSIDAD
-- Actividad práctica: Rediseño de Base de Datos Universitaria
-- MySQL 8.x
-- ============================================================

DROP DATABASE IF EXISTS universidad;
CREATE DATABASE universidad CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE universidad;

-- 1. DEPARTAMENTO
CREATE TABLE departamento (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 2. PERSONA
CREATE TABLE persona (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nif VARCHAR(9) NOT NULL UNIQUE,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('H','M') NOT NULL,
    tipo ENUM('profesor','alumno') NOT NULL
) ENGINE=InnoDB;

-- 3. PROFESOR
CREATE TABLE profesor (
    id_profesor INT UNSIGNED PRIMARY KEY,
    id_departamento INT UNSIGNED NOT NULL,
    CONSTRAINT fk_profesor_persona
        FOREIGN KEY (id_profesor) REFERENCES persona(id),
    CONSTRAINT fk_profesor_departamento
        FOREIGN KEY (id_departamento) REFERENCES departamento(id)
) ENGINE=InnoDB;

-- 4. GRADO
CREATE TABLE grado (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 5. ALUMNO
CREATE TABLE alumno (
    id_alumno INT UNSIGNED PRIMARY KEY,
    id_grado INT UNSIGNED NOT NULL,
    CONSTRAINT fk_alumno_persona
        FOREIGN KEY (id_alumno) REFERENCES persona(id),
    CONSTRAINT fk_alumno_grado
        FOREIGN KEY (id_grado) REFERENCES grado(id)
) ENGINE=InnoDB;

-- 6. CURSO ESCOLAR
CREATE TABLE curso_escolar (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    anyo_inicio YEAR NOT NULL,
    anyo_fin YEAR NOT NULL,
    CONSTRAINT chk_curso_anios CHECK (anyo_fin = anyo_inicio + 1)
) ENGINE=InnoDB;

-- 7. ASIGNATURA
CREATE TABLE asignatura (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos DECIMAL(4,1) NOT NULL,
    tipo ENUM('basica','obligatoria','optativa') NOT NULL,
    curso TINYINT UNSIGNED NOT NULL,
    cuatrimestre TINYINT UNSIGNED NOT NULL,
    id_grado INT UNSIGNED NOT NULL,
    CONSTRAINT chk_asignatura_creditos CHECK (creditos > 0),
    CONSTRAINT chk_asignatura_curso CHECK (curso BETWEEN 1 AND 5),
    CONSTRAINT chk_asignatura_cuatrimestre CHECK (cuatrimestre IN (1,2)),
    CONSTRAINT fk_asignatura_grado
        FOREIGN KEY (id_grado) REFERENCES grado(id)
) ENGINE=InnoDB;

-- 8. PROFESOR-ASIGNATURA
CREATE TABLE profesor_asignatura (
    id_profesor INT UNSIGNED NOT NULL,
    id_asignatura INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_profesor, id_asignatura, id_curso_escolar),
    CONSTRAINT fk_pa_profesor
        FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    CONSTRAINT fk_pa_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    CONSTRAINT fk_pa_curso
        FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
) ENGINE=InnoDB;

-- 9. ALUMNO SE MATRICULA EN ASIGNATURA
CREATE TABLE alumno_se_matricula_asignatura (
    id_alumno INT UNSIGNED NOT NULL,
    id_asignatura INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_alumno, id_asignatura, id_curso_escolar),
    CONSTRAINT fk_matricula_alumno
        FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno),
    CONSTRAINT fk_matricula_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    CONSTRAINT fk_matricula_curso
        FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
) ENGINE=InnoDB;

-- 10. CALIFICACIONES
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
    CONSTRAINT chk_primer_parcial CHECK (primer_parcial BETWEEN 0 AND 5),
    CONSTRAINT chk_segundo_parcial CHECK (segundo_parcial BETWEEN 0 AND 5),
    CONSTRAINT chk_parcial_final CHECK (parcial_final BETWEEN 0 AND 5),
    CONSTRAINT chk_trabajo_practico CHECK (trabajo_practico IS NULL OR trabajo_practico BETWEEN 0 AND 5),
    CONSTRAINT fk_calificacion_matricula
        FOREIGN KEY (id_alumno, id_asignatura, id_curso_escolar)
        REFERENCES alumno_se_matricula_asignatura(id_alumno, id_asignatura, id_curso_escolar)
) ENGINE=InnoDB;

-- Vista para consultar el historial académico.
CREATE OR REPLACE VIEW historial_calificaciones AS
SELECT
    c.id_calificacion,
    a.id_alumno,
    CONCAT(p.nombre, ' ', p.apellido1, ' ', COALESCE(p.apellido2,'')) AS alumno,
    asig.id AS id_asignatura,
    asig.nombre AS asignatura,
    ce.anyo_inicio,
    ce.anyo_fin,
    c.primer_parcial,
    c.segundo_parcial,
    c.parcial_final,
    c.trabajo_practico,
    ROUND(
        CASE
            WHEN c.trabajo_practico IS NULL THEN
                c.primer_parcial * 0.20 +
                c.segundo_parcial * 0.35 +
                c.parcial_final * 0.45
            ELSE
                c.primer_parcial * 0.20 +
                c.segundo_parcial * 0.35 +
                c.parcial_final * 0.35 +
                c.trabajo_practico * 0.10
        END, 2
    ) AS nota_final,
    CASE
        WHEN (
            CASE
                WHEN c.trabajo_practico IS NULL THEN
                    c.primer_parcial * 0.20 + c.segundo_parcial * 0.35 + c.parcial_final * 0.45
                ELSE
                    c.primer_parcial * 0.20 + c.segundo_parcial * 0.35 +
                    c.parcial_final * 0.35 + c.trabajo_practico * 0.10
            END
        ) >= 3.0 THEN 'APROBADO'
        ELSE 'REPROBADO'
    END AS estado
FROM calificaciones c
INNER JOIN alumno a ON a.id_alumno = c.id_alumno
INNER JOIN persona p ON p.id = a.id_alumno
INNER JOIN asignatura asig ON asig.id = c.id_asignatura
INNER JOIN curso_escolar ce ON ce.id = c.id_curso_escolar;
