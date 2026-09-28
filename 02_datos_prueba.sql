-- ============================================================
-- 02. DATOS DE PRUEBA
-- ============================================================
USE universidad;

INSERT INTO departamento (nombre) VALUES
('Ingeniería de Sistemas'),
('Ciencias Básicas'),
('Administración'),
('Humanidades');

INSERT INTO persona
(nif,nombre,apellido1,apellido2,ciudad,direccion,telefono,fecha_nacimiento,sexo,tipo)
VALUES
('100000001','Carlos','Gómez','Ruiz','Popayán','Cra 1 # 2-03','310000001','1985-03-12','H','profesor'),
('100000002','Laura','Martínez','Pérez','Popayán','Cra 2 # 4-05','310000002','1988-07-21','M','profesor'),
('100000003','Andrés','Torres','López','Cali','Calle 5 # 6-07','310000003','1982-11-08','H','profesor'),
('100000004','María','Rodríguez','Díaz','Popayán','Calle 8 # 9-10','310000004','2003-01-15','M','alumno'),
('100000005','Juan','Pérez','Gómez','Popayán','Cra 10 # 11-12','310000005','2002-05-18','H','alumno'),
('100000006','Daniela','López','Ruiz','Cali','Calle 12 # 13-14','310000006','2004-09-23','M','alumno'),
('100000007','Sebastián','Martínez','Torres','Pasto','Cra 15 # 16-17','310000007','2001-12-02','H','alumno'),
('100000008','Camila','García','Pérez','Popayán','Calle 18 # 19-20','310000008','2003-06-10','M','alumno'),
('100000009','Mateo','Hernández','Ruiz','Popayán','Cra 21 # 22-23','310000009','2002-10-30','H','alumno'),
('100000010','Valentina','Cruz','Díaz','Cali','Calle 24 # 25-26','310000010','2004-02-17','M','alumno');

INSERT INTO profesor (id_profesor,id_departamento) VALUES
(1,1),(2,1),(3,2);

INSERT INTO grado (nombre) VALUES
('Análisis y Desarrollo de Software'),
('Ingeniería de Sistemas'),
('Administración de Empresas');

INSERT INTO alumno (id_alumno,id_grado) VALUES
(4,1),(5,1),(6,1),(7,2),(8,2),(9,1),(10,3);

INSERT INTO curso_escolar (anyo_inicio,anyo_fin) VALUES
(2024,2025),(2025,2026),(2026,2027);

INSERT INTO asignatura
(nombre,creditos,tipo,curso,cuatrimestre,id_grado)
VALUES
('Bases de Datos',4.0,'obligatoria',1,1,1),
('Programación',5.0,'obligatoria',1,1,1),
('Matemáticas',4.0,'basica',1,2,1),
('Ingeniería de Software',4.0,'obligatoria',2,1,1),
('Redes',3.0,'optativa',2,2,1),
('Sistemas Operativos',4.0,'obligatoria',2,1,2),
('Administración',3.0,'basica',1,1,3);

INSERT INTO profesor_asignatura (id_profesor,id_asignatura,id_curso_escolar) VALUES
(1,1,3),(1,2,3),(2,3,3),(2,4,3),(3,6,3),(3,7,3),(1,5,3);

INSERT INTO alumno_se_matricula_asignatura
(id_alumno,id_asignatura,id_curso_escolar)
VALUES
(4,1,3),(4,2,3),(4,3,3),(4,4,3),
(5,1,3),(5,2,3),(5,3,3),
(6,1,3),(6,2,3),
(7,6,3),
(8,6,3),(8,1,3),
(9,1,3),(9,2,3),(9,4,3),
(10,7,3);

INSERT INTO calificaciones
(id_alumno,id_asignatura,id_curso_escolar,primer_parcial,segundo_parcial,parcial_final,trabajo_practico)
VALUES
(4,1,3,4.2,4.0,4.5,4.6),
(4,2,3,3.8,4.1,4.0,NULL),
(4,3,3,2.8,3.2,3.0,3.5),
(4,4,3,4.5,4.3,4.6,NULL),
(5,1,3,2.5,2.8,2.7,NULL),
(5,2,3,3.5,3.8,4.0,4.2),
(5,3,3,4.0,4.1,4.2,NULL),
(6,1,3,4.8,4.5,4.7,4.9),
(6,2,3,4.2,4.0,4.4,NULL),
(7,6,3,3.0,3.2,3.5,NULL),
(8,6,3,2.4,2.8,2.6,NULL),
(8,1,3,3.9,4.0,3.8,4.1),
(9,1,3,4.0,3.7,4.2,NULL),
(9,2,3,3.1,3.0,3.4,3.6),
(9,4,3,4.6,4.4,4.5,NULL),
(10,7,3,3.8,4.0,3.9,4.1);

-- La matrícula del alumno 10 queda sin calificación para validar
-- estudiantes pendientes de evaluación.
