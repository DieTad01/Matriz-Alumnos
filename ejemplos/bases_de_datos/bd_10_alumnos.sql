-- Datos FICTICIOS de prueba.
BEGIN TRANSACTION;
CREATE TABLE alumnos (
    id INTEGER PRIMARY KEY,
    matricula TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    programa_id INTEGER NOT NULL REFERENCES programas(id),
    especialidad_actual_id INTEGER REFERENCES especialidades(id),
    semestre_actual INTEGER CHECK (
        semestre_actual IS NULL OR semestre_actual > 0
    ),
    grupo TEXT,
    turno TEXT,
    campus TEXT,
    fecha_corte TEXT
);
INSERT INTO "alumnos" VALUES(1,'EJEMPLO001','Alumno Ficticio 01',1,2,5,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(2,'EJEMPLO002','Alumno Ficticio 02',1,2,8,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(3,'EJEMPLO003','Alumno Ficticio 03',1,2,12,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(4,'EJEMPLO004','Alumno Ficticio 04',1,2,1,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(5,'EJEMPLO00005','Alumno Ficticio 00005',1,2,2,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(6,'EJEMPLO00006','Alumno Ficticio 00006',1,2,7,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(7,'EJEMPLO00007','Alumno Ficticio 00007',1,2,8,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(8,'EJEMPLO00008','Alumno Ficticio 00008',1,2,8,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(9,'EJEMPLO00009','Alumno Ficticio 00009',1,2,5,NULL,NULL,NULL,NULL);
INSERT INTO "alumnos" VALUES(10,'EJEMPLO00010','Alumno Ficticio 00010',1,2,9,NULL,NULL,NULL,NULL);
CREATE TABLE especialidades (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    version_reticula TEXT NOT NULL,
    creditos_totales REAL CHECK (creditos_totales IS NULL OR creditos_totales > 0)
);
INSERT INTO "especialidades" VALUES(1,'ISIE-COE-2024-02','Cómputo Empresarial','2024-02',25.0);
INSERT INTO "especialidades" VALUES(2,'ISIE-SIA-2024-03','Sistemas basados en Inteligencia Artificial','2024-03',25.0);
CREATE TABLE intentos_academicos (
    id INTEGER PRIMARY KEY,
    alumno_id INTEGER NOT NULL REFERENCES alumnos(id) ON DELETE CASCADE,
    materia_id INTEGER NOT NULL REFERENCES materias(id),
    numero_intento INTEGER NOT NULL CHECK (numero_intento > 0),
    periodo TEXT NOT NULL,
    semestre_cursado INTEGER CHECK (
        semestre_cursado IS NULL OR semestre_cursado > 0
    ),
    tipo_intento TEXT NOT NULL
        CHECK (tipo_intento IN ('ordinario', 'repeticion', 'especial')),
    calificacion_numerica REAL,
    calificacion_textual TEXT,
    resultado TEXT NOT NULL
        CHECK (resultado IN ('aprobada', 'reprobada', 'en_curso')),
    observaciones TEXT,
    UNIQUE (alumno_id, materia_id, numero_intento)
);
INSERT INTO "intentos_academicos" VALUES(1,1,1,3,'EJEMPLO',NULL,'especial',59.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(2,1,2,3,'EJEMPLO',NULL,'especial',48.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(3,2,1,1,'EJEMPLO',NULL,'ordinario',93.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(4,2,2,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(5,2,3,1,'EJEMPLO',NULL,'ordinario',95.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(6,2,4,1,'EJEMPLO',NULL,'ordinario',92.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(7,2,5,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(8,2,6,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(9,2,7,1,'EJEMPLO',NULL,'ordinario',93.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(10,2,8,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(11,2,9,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(12,2,10,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(13,2,11,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(14,2,12,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(15,2,13,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(16,2,14,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(17,2,37,3,'EJEMPLO',NULL,'especial',47.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(18,3,1,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(19,3,2,1,'EJEMPLO',NULL,'ordinario',71.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(20,3,3,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(21,3,4,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(22,3,5,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(23,3,6,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(24,3,7,1,'EJEMPLO',NULL,'ordinario',85.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(25,3,8,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(26,3,9,1,'EJEMPLO',NULL,'ordinario',77.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(27,3,10,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(28,3,11,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(29,3,12,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(30,3,13,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(31,3,14,1,'EJEMPLO',NULL,'ordinario',77.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(32,3,15,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(33,3,16,1,'EJEMPLO',NULL,'ordinario',93.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(34,3,17,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(35,3,18,1,'EJEMPLO',NULL,'ordinario',83.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(36,3,19,1,'EJEMPLO',NULL,'ordinario',78.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(37,3,20,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(38,3,21,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(39,3,22,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(40,3,23,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(41,3,24,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(42,3,25,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(43,3,26,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(44,3,27,1,'EJEMPLO',NULL,'ordinario',95.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(45,3,28,1,'EJEMPLO',NULL,'ordinario',72.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(46,3,29,1,'EJEMPLO',NULL,'ordinario',74.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(47,3,30,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(48,3,31,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(49,3,32,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(50,3,33,1,'EJEMPLO',NULL,'ordinario',74.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(51,3,34,1,'EJEMPLO',NULL,'ordinario',74.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(52,3,35,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(53,3,36,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(54,3,37,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(55,3,38,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(56,3,39,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(57,3,40,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(58,3,41,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(59,3,42,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(60,3,43,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(61,3,44,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(62,3,45,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(63,3,46,1,'EJEMPLO',NULL,'ordinario',80.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(64,3,47,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(65,3,48,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(66,3,49,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(67,3,50,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(68,3,51,1,'EJEMPLO',NULL,'ordinario',91.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(69,3,52,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(70,3,53,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(71,3,54,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(72,3,55,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(73,3,56,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(74,3,57,1,'EJEMPLO',NULL,'ordinario',92.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(75,3,58,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(76,3,59,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(77,3,60,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(78,3,61,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(79,3,62,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(80,3,63,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(81,3,64,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(82,3,65,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(83,3,66,1,'EJEMPLO',NULL,'ordinario',83.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(84,3,67,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(85,3,68,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(86,5,1,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(87,5,2,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(88,5,3,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(89,5,4,1,'EJEMPLO',NULL,'ordinario',95.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(90,5,5,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(91,5,6,1,'EJEMPLO',NULL,'ordinario',72.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(92,5,7,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(93,6,1,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(94,6,2,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(95,6,3,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(96,6,4,1,'EJEMPLO',NULL,'ordinario',78.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(97,6,5,1,'EJEMPLO',NULL,'ordinario',91.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(98,6,6,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(99,6,7,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(100,6,8,1,'EJEMPLO',NULL,'ordinario',47.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(101,6,9,1,'EJEMPLO',NULL,'ordinario',59.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(102,6,10,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(103,6,11,1,'EJEMPLO',NULL,'ordinario',74.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(104,6,12,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(105,6,13,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(106,6,14,1,'EJEMPLO',NULL,'ordinario',77.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(107,6,16,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(108,6,17,1,'EJEMPLO',NULL,'ordinario',85.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(109,6,18,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(110,6,19,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(111,6,21,1,'EJEMPLO',NULL,'ordinario',77.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(112,6,22,1,'EJEMPLO',NULL,'ordinario',47.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(113,6,23,1,'EJEMPLO',NULL,'ordinario',85.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(114,6,24,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(115,6,25,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(116,6,26,1,'EJEMPLO',NULL,'ordinario',42.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(117,6,27,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(118,6,28,1,'EJEMPLO',NULL,'ordinario',69.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(119,6,29,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(120,6,30,1,'EJEMPLO',NULL,'ordinario',64.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(121,6,31,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(122,6,32,1,'EJEMPLO',NULL,'ordinario',46.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(123,6,33,1,'EJEMPLO',NULL,'ordinario',53.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(124,6,34,1,'EJEMPLO',NULL,'ordinario',54.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(125,6,35,1,'EJEMPLO',NULL,'ordinario',78.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(126,6,36,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(127,6,37,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(128,6,38,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(129,6,39,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(130,6,40,1,'EJEMPLO',NULL,'ordinario',45.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(131,6,41,1,'EJEMPLO',NULL,'ordinario',85.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(132,6,42,1,'EJEMPLO',NULL,'ordinario',80.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(133,7,1,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(134,7,2,1,'EJEMPLO',NULL,'ordinario',80.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(135,7,3,1,'EJEMPLO',NULL,'ordinario',47.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(136,7,4,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(137,7,5,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(138,7,6,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(139,7,7,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(140,7,8,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(141,7,9,1,'EJEMPLO',NULL,'ordinario',48.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(142,7,10,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(143,7,11,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(144,7,12,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(145,7,13,1,'EJEMPLO',NULL,'ordinario',44.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(146,7,14,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(147,7,16,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(148,7,17,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(149,7,18,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(150,7,19,1,'EJEMPLO',NULL,'ordinario',53.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(151,7,21,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(152,7,22,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(153,7,23,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(154,7,24,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(155,7,25,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(156,7,26,1,'EJEMPLO',NULL,'ordinario',55.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(157,7,27,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(158,7,28,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(159,7,29,1,'EJEMPLO',NULL,'ordinario',50.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(160,7,30,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(161,7,31,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(162,7,32,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(163,7,33,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(164,7,34,1,'EJEMPLO',NULL,'ordinario',77.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(165,7,35,1,'EJEMPLO',NULL,'ordinario',71.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(166,7,36,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(167,7,37,1,'EJEMPLO',NULL,'ordinario',58.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(168,7,38,1,'EJEMPLO',NULL,'ordinario',85.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(169,7,39,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(170,7,40,1,'EJEMPLO',NULL,'ordinario',53.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(171,7,42,1,'EJEMPLO',NULL,'ordinario',47.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(172,7,43,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(173,7,44,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(174,7,45,1,'EJEMPLO',NULL,'ordinario',64.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(175,7,46,1,'EJEMPLO',NULL,'ordinario',43.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(176,7,47,1,'EJEMPLO',NULL,'ordinario',49.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(177,7,48,1,'EJEMPLO',NULL,'ordinario',85.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(178,7,49,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(179,8,1,1,'EJEMPLO',NULL,'ordinario',46.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(180,8,2,1,'EJEMPLO',NULL,'ordinario',45.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(181,8,3,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(182,8,4,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(183,8,5,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(184,8,6,1,'EJEMPLO',NULL,'ordinario',54.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(185,8,8,1,'EJEMPLO',NULL,'ordinario',64.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(186,8,10,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(187,8,11,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(188,8,12,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(189,8,14,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(190,8,16,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(191,8,17,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(192,8,18,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(193,8,19,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(194,8,21,1,'EJEMPLO',NULL,'ordinario',60.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(195,8,22,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(196,8,23,1,'EJEMPLO',NULL,'ordinario',72.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(197,8,24,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(198,8,25,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(199,8,26,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(200,8,27,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(201,8,28,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(202,8,29,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(203,8,30,1,'EJEMPLO',NULL,'ordinario',52.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(204,8,31,1,'EJEMPLO',NULL,'ordinario',80.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(205,8,32,1,'EJEMPLO',NULL,'ordinario',78.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(206,8,33,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(207,8,34,1,'EJEMPLO',NULL,'ordinario',58.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(208,8,35,1,'EJEMPLO',NULL,'ordinario',92.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(209,8,36,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(210,8,37,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(211,8,38,1,'EJEMPLO',NULL,'ordinario',45.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(212,8,39,1,'EJEMPLO',NULL,'ordinario',53.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(213,8,40,1,'EJEMPLO',NULL,'ordinario',72.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(214,8,41,1,'EJEMPLO',NULL,'ordinario',93.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(215,8,42,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(216,8,43,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(217,8,44,1,'EJEMPLO',NULL,'ordinario',93.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(218,8,45,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(219,8,46,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(220,8,47,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(221,8,48,1,'EJEMPLO',NULL,'ordinario',95.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(222,8,49,1,'EJEMPLO',NULL,'ordinario',71.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(223,9,1,1,'EJEMPLO',NULL,'ordinario',72.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(224,9,2,1,'EJEMPLO',NULL,'ordinario',46.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(225,9,3,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(226,9,4,1,'EJEMPLO',NULL,'ordinario',65.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(227,9,5,1,'EJEMPLO',NULL,'ordinario',40.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(228,9,6,1,'EJEMPLO',NULL,'ordinario',80.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(229,9,7,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(230,9,8,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(231,9,10,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(232,9,11,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(233,9,12,1,'EJEMPLO',NULL,'ordinario',71.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(234,9,13,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(235,9,14,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(236,9,16,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(237,9,17,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(238,9,18,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(239,9,19,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(240,9,21,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(241,9,22,1,'EJEMPLO',NULL,'ordinario',40.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(242,9,23,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(243,9,24,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(244,9,25,1,'EJEMPLO',NULL,'ordinario',84.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(245,9,26,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(246,9,27,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(247,9,28,1,'EJEMPLO',NULL,'ordinario',62.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(248,10,1,1,'EJEMPLO',NULL,'ordinario',93.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(249,10,2,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(250,10,3,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(251,10,4,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(252,10,5,1,'EJEMPLO',NULL,'ordinario',87.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(253,10,6,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(254,10,7,1,'EJEMPLO',NULL,'ordinario',83.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(255,10,8,1,'EJEMPLO',NULL,'ordinario',71.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(256,10,9,1,'EJEMPLO',NULL,'ordinario',45.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(257,10,10,1,'EJEMPLO',NULL,'ordinario',76.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(258,10,11,1,'EJEMPLO',NULL,'ordinario',99.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(259,10,12,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(260,10,13,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(261,10,14,1,'EJEMPLO',NULL,'ordinario',71.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(262,10,16,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(263,10,17,1,'EJEMPLO',NULL,'ordinario',41.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(264,10,18,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(265,10,19,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(266,10,21,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(267,10,22,1,'EJEMPLO',NULL,'ordinario',41.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(268,10,23,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(269,10,24,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(270,10,25,1,'EJEMPLO',NULL,'ordinario',85.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(271,10,26,1,'EJEMPLO',NULL,'ordinario',82.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(272,10,27,1,'EJEMPLO',NULL,'ordinario',100.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(273,10,28,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(274,10,29,1,'EJEMPLO',NULL,'ordinario',71.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(275,10,30,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(276,10,31,1,'EJEMPLO',NULL,'ordinario',92.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(277,10,32,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(278,10,33,1,'EJEMPLO',NULL,'ordinario',92.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(279,10,34,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(280,10,35,1,'EJEMPLO',NULL,'ordinario',96.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(281,10,36,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(282,10,37,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(283,10,38,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(284,10,39,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(285,10,40,1,'EJEMPLO',NULL,'ordinario',51.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(286,10,41,1,'EJEMPLO',NULL,'ordinario',86.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(287,10,42,1,'EJEMPLO',NULL,'ordinario',89.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(288,10,43,1,'EJEMPLO',NULL,'ordinario',79.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(289,10,44,1,'EJEMPLO',NULL,'ordinario',75.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(290,10,45,1,'EJEMPLO',NULL,'ordinario',52.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(291,10,46,1,'EJEMPLO',NULL,'ordinario',73.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(292,10,47,1,'EJEMPLO',NULL,'ordinario',94.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(293,10,48,1,'EJEMPLO',NULL,'ordinario',88.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(294,10,49,1,'EJEMPLO',NULL,'ordinario',58.0,NULL,'reprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(295,10,50,1,'EJEMPLO',NULL,'ordinario',81.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(296,10,51,1,'EJEMPLO',NULL,'ordinario',98.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(297,10,52,1,'EJEMPLO',NULL,'ordinario',97.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(298,10,53,1,'EJEMPLO',NULL,'ordinario',70.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(299,10,54,1,'EJEMPLO',NULL,'ordinario',95.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(300,10,55,1,'EJEMPLO',NULL,'ordinario',90.0,NULL,'aprobada',NULL);
INSERT INTO "intentos_academicos" VALUES(301,10,56,1,'EJEMPLO',NULL,'ordinario',80.0,NULL,'aprobada',NULL);
CREATE TABLE materias (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL
);
INSERT INTO "materias" VALUES(1,'ACF2301','Calculo Diferecial');
INSERT INTO "materias" VALUES(2,'AED1285','Fundamentos de Programacion');
INSERT INTO "materias" VALUES(3,'AEF1041','Matematicas Discretas');
INSERT INTO "materias" VALUES(4,'SCH1024','Taller de Administracion');
INSERT INTO "materias" VALUES(5,'ACC0906','Fundamentos de Investigacion');
INSERT INTO "materias" VALUES(6,'ACH2307','Taller de Etica');
INSERT INTO "materias" VALUES(7,'ACF0902','Calculo Integral');
INSERT INTO "materias" VALUES(8,'ACF0903','Algebra Lineal');
INSERT INTO "materias" VALUES(9,'AED1286','Programacion Orientada a Objetos');
INSERT INTO "materias" VALUES(10,'AEC1008','Contbilidad Financiera');
INSERT INTO "materias" VALUES(11,'AEC1058','Quimica');
INSERT INTO "materias" VALUES(12,'AEF1052','Probabilidad y Estadistica');
INSERT INTO "materias" VALUES(13,'ACF0904','Calculo Vectorial');
INSERT INTO "materias" VALUES(14,'SCC1013','Investigacion de Operaciones');
INSERT INTO "materias" VALUES(15,'AED1026','Estructura de Datos');
INSERT INTO "materias" VALUES(16,'SCF1006','Fisica General');
INSERT INTO "materias" VALUES(17,'ACD0908','Desarrollo Sustentble');
INSERT INTO "materias" VALUES(18,'SCC1005','Cultura Empresarial');
INSERT INTO "materias" VALUES(19,'ACF0905','Ecuaciones Diferenciales');
INSERT INTO "materias" VALUES(20,'SCD1027','Topicos Avanzados de Programacion');
INSERT INTO "materias" VALUES(21,'SCD1018','Pricipios Electricos y Aplicaciones Digitales');
INSERT INTO "materias" VALUES(22,'AEC1034','Fundamentos de Telecomunicaciones');
INSERT INTO "materias" VALUES(23,'AEF1031','Fundamentos de Base de Datos');
INSERT INTO "materias" VALUES(24,'SCC1017','Metodos Numericos');
INSERT INTO "materias" VALUES(25,'SCD1003','Arquitectura de Computadoras');
INSERT INTO "materias" VALUES(26,'SCD1021','Redes de Computadoras');
INSERT INTO "materias" VALUES(27,'SCA1025','Taller de Base de Datos');
INSERT INTO "materias" VALUES(28,'SCC1007','Fundamentos de Ingenieia de Software');
INSERT INTO "materias" VALUES(29,'SCC1012','Inteligencia Artificial');
INSERT INTO "materias" VALUES(30,'AEC1061','Sistemas Operativos');
INSERT INTO "materias" VALUES(31,'SCC1014','Lenguajes de interfaz');
INSERT INTO "materias" VALUES(32,'SCD1004','Conmutacion y Enrutamiento de Redes de Datos');
INSERT INTO "materias" VALUES(33,'SCA1026','Taller de Sistemas Operativos');
INSERT INTO "materias" VALUES(34,'SCB1001','Administracion de Base de Datos');
INSERT INTO "materias" VALUES(35,'SCD1011','Ingenieria de Software');
INSERT INTO "materias" VALUES(36,'ACA','Actividades complementarias');
INSERT INTO "materias" VALUES(37,'SCD1015','Lenguajes y Automatas I');
INSERT INTO "materias" VALUES(38,'SCD1023','Sistemas Programables');
INSERT INTO "materias" VALUES(39,'DAH2101','BASE DE DATOS AVANZADAS');
INSERT INTO "materias" VALUES(40,'SCG1009','Gestion de Proyectos de Software');
INSERT INTO "materias" VALUES(41,'SCD1016','Lenguajes y Automatas II');
INSERT INTO "materias" VALUES(42,'RAD2001','REDES INALAMBRICAS');
INSERT INTO "materias" VALUES(43,'SID2401','MACHINE LEARNING');
INSERT INTO "materias" VALUES(44,'COH2401','TOPICOS PARA EL DESPLIEGUE DE APLICACIONES');
INSERT INTO "materias" VALUES(45,'AEB1055','Programacion Web');
INSERT INTO "materias" VALUES(46,'SCC1010','Graficacion');
INSERT INTO "materias" VALUES(47,'DAH2103','CIENCIA DE DATOS');
INSERT INTO "materias" VALUES(48,'RAD2002','DISEÅO DE REDES');
INSERT INTO "materias" VALUES(49,'RAD2003','FUNDAMENTOS DE IOT');
INSERT INTO "materias" VALUES(50,'SID2402','LINGUISTICA COMPUTACIONAL');
INSERT INTO "materias" VALUES(51,'SID2403','SOFTCOMPUTING');
INSERT INTO "materias" VALUES(52,'S1','Servicio Social');
INSERT INTO "materias" VALUES(53,'COC2403','SERVICIOS EN LA NUBE');
INSERT INTO "materias" VALUES(54,'COH2405','DESARROLLO DE APLICACIONES MOVILES');
INSERT INTO "materias" VALUES(55,'DAC2104','COMPUTO Y SERVICIOS EN LA NUBE');
INSERT INTO "materias" VALUES(56,'DAH2102','DESARROLLO DE APLICACIONES PARA DISP. MOVILES');
INSERT INTO "materias" VALUES(57,'COC2402','INTELIGENCIA DE NEGOCIOS I');
INSERT INTO "materias" VALUES(58,'SID2404','PROCESAMIENTO DIGITAL DE SEÅALES');
INSERT INTO "materias" VALUES(59,'ACA0909','Taller de Investigacion I');
INSERT INTO "materias" VALUES(60,'SCA1002','Administracion de Redes');
INSERT INTO "materias" VALUES(61,'SCC1019','Programacion Logica y Funcional');
INSERT INTO "materias" VALUES(62,'COB2406','PROYECTO INTEGRADOR PARA APLICACIONES EMPRESARIALES');
INSERT INTO "materias" VALUES(63,'DAH2105','DESARROLLO DE APLICACIONES EMPRESARIALES');
INSERT INTO "materias" VALUES(64,'DAD2106','LAB. PARA EL DESPLIEGUE DE APLIC. EMP.');
INSERT INTO "materias" VALUES(65,'COC2404','INTELIGENCIA DE NEGOCIOS II');
INSERT INTO "materias" VALUES(66,'SID2405','INTRODUCCION A LA COMPUTACION CUANTICA');
INSERT INTO "materias" VALUES(67,'ACA0910','Taller de Investigacion II');
INSERT INTO "materias" VALUES(68,'RAD2005','INFRAEST. EMERGENTE PARA EL DESPL. DE APLIC.');
INSERT INTO "materias" VALUES(69,'RAD2004','SEGURIDAD EN REDES');
INSERT INTO "materias" VALUES(70,'SCD1022','Simulacion');
INSERT INTO "materias" VALUES(71,'R1','Residencia');
CREATE TABLE materias_reticula (
    id INTEGER PRIMARY KEY,
    reticula_id INTEGER NOT NULL REFERENCES reticulas(id) ON DELETE CASCADE,
    materia_id INTEGER NOT NULL REFERENCES materias(id),
    numero_nodo INTEGER,
    semestre_sugerido INTEGER CHECK (
        semestre_sugerido IS NULL OR semestre_sugerido > 0
    ),
    creditos REAL NOT NULL CHECK (creditos > 0),
    categoria TEXT NOT NULL DEFAULT 'generica'
        CHECK (categoria IN (
            'generica', 'especialidad', 'actividad_complementaria',
            'servicio_social', 'residencia'
        )),
    UNIQUE (reticula_id, materia_id),
    UNIQUE (reticula_id, numero_nodo),
    UNIQUE (id, reticula_id)
);
INSERT INTO "materias_reticula" VALUES(1,2,1,1,1,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(2,2,2,2,1,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(3,2,3,3,1,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(4,2,4,4,1,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(5,2,5,5,1,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(6,2,6,6,1,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(7,2,7,7,1,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(8,2,8,8,2,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(9,2,9,9,2,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(10,2,10,10,2,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(11,2,11,11,2,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(12,2,12,12,2,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(13,2,13,13,2,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(14,2,14,14,2,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(15,2,15,15,3,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(16,2,16,16,3,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(17,2,17,17,3,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(18,2,18,18,3,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(19,2,19,19,3,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(20,2,20,20,3,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(21,2,21,21,3,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(22,2,22,22,4,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(23,2,23,23,4,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(24,2,24,24,4,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(25,2,25,25,4,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(26,2,26,26,4,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(27,2,27,27,4,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(28,2,28,28,4,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(29,2,29,29,5,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(30,2,30,30,5,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(31,2,31,31,5,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(32,2,32,32,5,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(33,2,33,33,5,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(34,2,34,34,5,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(35,2,35,35,5,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(36,2,36,36,6,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(37,2,37,37,6,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(38,2,38,38,6,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(39,2,39,39,6,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(40,2,40,40,6,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(41,2,41,41,6,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(42,2,42,42,6,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(43,2,43,43,7,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(44,2,44,44,7,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(45,2,45,45,7,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(46,2,46,46,7,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(47,2,47,47,7,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(48,2,48,48,7,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(49,2,49,49,7,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(50,2,50,50,8,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(51,2,51,51,8,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(52,2,52,52,8,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(53,2,53,53,8,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(54,2,54,54,8,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(55,2,55,55,8,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(56,2,56,56,8,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(57,2,57,57,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(58,2,58,58,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(59,2,59,59,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(60,2,60,60,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(61,2,61,61,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(62,2,62,62,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(63,2,63,63,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(64,2,64,64,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(65,2,65,65,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(66,2,66,66,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(67,2,67,67,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(68,2,68,68,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(69,2,69,69,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(70,2,70,70,9,5.0,'generica');
INSERT INTO "materias_reticula" VALUES(71,2,71,71,9,5.0,'generica');
CREATE TABLE prerrequisitos (
    reticula_id INTEGER NOT NULL REFERENCES reticulas(id) ON DELETE CASCADE,
    materia_reticula_id INTEGER NOT NULL,
    requisito_reticula_id INTEGER NOT NULL,
    PRIMARY KEY (reticula_id, materia_reticula_id, requisito_reticula_id),
    FOREIGN KEY (materia_reticula_id, reticula_id)
        REFERENCES materias_reticula(id, reticula_id) ON DELETE CASCADE,
    FOREIGN KEY (requisito_reticula_id, reticula_id)
        REFERENCES materias_reticula(id, reticula_id) ON DELETE CASCADE,
    CHECK (materia_reticula_id <> requisito_reticula_id)
);
INSERT INTO "prerrequisitos" VALUES(2,7,1);
INSERT INTO "prerrequisitos" VALUES(2,13,7);
INSERT INTO "prerrequisitos" VALUES(2,9,2);
INSERT INTO "prerrequisitos" VALUES(2,15,9);
INSERT INTO "prerrequisitos" VALUES(2,20,9);
INSERT INTO "prerrequisitos" VALUES(2,27,23);
INSERT INTO "prerrequisitos" VALUES(2,34,27);
INSERT INTO "prerrequisitos" VALUES(2,41,37);
INSERT INTO "prerrequisitos" VALUES(2,67,59);
CREATE TABLE programas (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL
);
INSERT INTO "programas" VALUES(1,'ISIC-2010-224','Ingeniería en Sistemas Computacionales');
CREATE TABLE reticulas (
    id INTEGER PRIMARY KEY,
    clave TEXT NOT NULL UNIQUE,
    programa_id INTEGER NOT NULL REFERENCES programas(id),
    especialidad_id INTEGER REFERENCES especialidades(id),
    version TEXT NOT NULL,
    fecha_actualizacion TEXT,
    CHECK (especialidad_id IS NULL OR especialidad_id > 0)
);
INSERT INTO "reticulas" VALUES(1,'ISIE-COE-2024-02',1,1,'2024-02','2023-12-14');
INSERT INTO "reticulas" VALUES(2,'ISIE-SIA-2024-03',1,2,'2024-03','2023-12-14');
CREATE INDEX idx_intentos_alumno
    ON intentos_academicos(alumno_id);
CREATE INDEX idx_intentos_materia
    ON intentos_academicos(materia_id);
CREATE INDEX idx_materias_reticula
    ON materias_reticula(reticula_id);
COMMIT;
