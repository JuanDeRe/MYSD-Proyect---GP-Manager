-- Tablas
CREATE TABLE Torneos(
    id VARCHAR2(20) NOT NULL,
    nombre VARCHAR2(40) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    cupo NUMBER(3) NOT NULL,
    plataforma_principal VARCHAR2(15) NOT NULL,
    estado VARCHAR2(15) NOT NULL,
    organizador VARCHAR2(10) NOT NULL,
    juego VARCHAR2(20) NOT NULL
);

CREATE TABLE Eventos(
    id NUMBER(4) NOT NULL,
    fecha DATE NOT NULL,
    clima VARCHAR2(20) NOT NULL,
    hora_in_game VARCHAR2(5) NOT NULL,
    estado VARCHAR2(15) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    circuito VARCHAR2(40) NOT NULL
);

CREATE TABLE Carreras(
    id NUMBER(4) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    numero_vueltas NUMBER(3) NOT NULL
);

CREATE TABLE Clasificaciones(
    id NUMBER(4) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    duracion VARCHAR2(5) NOT NULL
);

CREATE TABLE Practicas (
    id NUMBER(4) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    duracion VARCHAR2(5) NOT NULL
);

CREATE TABLE Juegos (
    nombre VARCHAR2(20) NOT NULL
);

CREATE TABLE Circuitos(
    nombre VARCHAR2(40) NOT NULL,
    pais VARCHAR2(20) NOT NULL,
    longitud NUMBER(6,2) NOT NULL
);

CREATE TABLE CircuitosDisponibles(
    juego VARCHAR2(20) NOT NULL,
    circuito VARCHAR2(40) NOT NULL,
    clima VARCHAR2(20) NOT NULL
);

CREATE TABLE VehiculosDeJuegos(
    juego VARCHAR2(20) NOT NULL,
    marca_vehiculo VARCHAR2(15) NOT NULL,
    referencia_vehiculo VARCHAR2(30) NOT NULL
);

CREATE TABLE VehiculosPorTorneo(
    torneo VARCHAR2(20) NOT NULL,
    marca_vehiculo VARCHAR2(15) NOT NULL,
    referencia_vehiculo VARCHAR2(30) NOT NULL
);

CREATE TABLE Vehiculos(
    marca VARCHAR2(15) NOT NULL,
    referencia VARCHAR2(30) NOT NULL,
    año NUMBER(4) NOT NULL,
    categoria VARCHAR2(20),
    peso NUMBER(6,2),
    hp NUMBER(4)
);

CREATE TABLE Organizadores(
    id VARCHAR2(10) NOT NULL,
    total_torneos_creados NUMBER(6)
);

CREATE TABLE Usuarios(
    id VARCHAR2(10) NOT NULL,
    nombre_usuario VARCHAR2(15) NOT NULL,
    correo VARCHAR2(80),
    pais VARCHAR2(20) NOT NULL,
    fecha_registro DATE NOT NULL
);

-- Atributos
ALTER TABLE Torneos
ADD CONSTRAINT chk_torneos_id CHECK (LENGTH(id) = 20)
ADD CONSTRAINT chk_torneos_plataforma CHECK (plataforma_principal IN ('PC', 'Xbox', 'PlayStation', 'Nintendo', 'Multiplataforma'))
ADD CONSTRAINT chk_torneos_cupo CHECK (cupo > 1 AND cupo <= 999)
ADD CONSTRAINT chk_torneos_estado CHECK (estado IN ('Programado', 'En curso', 'Finalizado'));

ALTER TABLE Eventos
ADD CONSTRAINT chk_eventos_id CHECK (id >= 0 AND id <= 9999)
ADD CONSTRAINT chk_eventos_fecha CHECK (TO_CHAR(fecha, 'HH24:MI') <> '00:00')
ADD CONSTRAINT chk_eventos_clima CHECK (clima IN ('Despejado', 'Nublado', 'Lluvia ligera', 'Lluvia fuerte', 'Dinamico'))
ADD CONSTRAINT chk_eventos_hora_in_game CHECK (REGEXP_LIKE(hora_in_game, '^([01][0-9]|2[0-3]):[0-5][0-9]$') OR hora_in_game IS NULL)
ADD CONSTRAINT chk_eventos_estado CHECK (estado IN ('Programado', 'En curso', 'Finalizado'));

ALTER TABLE Carreras
ADD CONSTRAINT chk_carreras_numero_vueltas CHECK (numero_vueltas > 0 AND numero_vueltas <= 999);

ALTER TABLE Clasificaciones
ADD CONSTRAINT chk_clasificaciones_duracion CHECK (REGEXP_LIKE(duracion, '^([0-1][0-9]|2[0-3]):[0-5][0-9]$'));

ALTER TABLE Practicas
ADD CONSTRAINT chk_practicas_duracion CHECK (REGEXP_LIKE(duracion, '^([0-1][0-9]|2[0-3]):[0-5][0-9]$'));

ALTER TABLE Usuarios
ADD CONSTRAINT chk_usuarios_id CHECK (LENGTH(id) = 10 )
ADD CONSTRAINT chk_usuarios_nombre_usuario CHECK (LENGTH(nombre_usuario) >= 3 AND LENGTH(nombre_usuario) <= 15 AND NOT (nombre_usuario LIKE '% %'))
ADD CONSTRAINT chk_usuarios_correo CHECK ((correo LIKE '%_@__%.__%') OR correo IS NULL);

ALTER TABLE Organizadores
ADD CONSTRAINT chk_organizadores_total_torneos_creados CHECK (total_torneos_creados >= 0 AND total_torneos_creados <= 999999);

ALTER TABLE Circuitos
ADD CONSTRAINT chk_circuitos_longitud CHECK (longitud > 0 AND longitud <= 999999);

ALTER TABLE CircuitosDisponibles
ADD CONSTRAINT chk_circuitosdisponibles_clima CHECK (clima IN ('Despejado', 'Nublado', 'Lluvia ligera', 'Lluvia fuerte', 'Dinamico'));

ALTER TABLE Vehiculos
ADD CONSTRAINT chk_vehiculos_año CHECK (año >= 0)
ADD CONSTRAINT chk_vehiculos_categoria CHECK (categoria IN ('Calle', 'Deportivo', 'Rally', 'Nascar', 'Clasico', 'Monoplaza', 'Prototipo', 'Gran Turismo', 'Otro'))
ADD CONSTRAINT chk_vehiculos_peso CHECK ((peso > 0 AND peso <= 9999.99) OR peso IS NULL)
ADD CONSTRAINT chk_vehiculos_hp CHECK ((hp > 0 AND hp <= 9999) OR hp IS NULL);

-- Llaves primarias
ALTER TABLE Torneos ADD CONSTRAINT pk_torneos PRIMARY KEY (id);
ALTER TABLE Eventos ADD CONSTRAINT pk_eventos PRIMARY KEY (id, torneo); 
ALTER TABLE Carreras ADD CONSTRAINT pk_carreras PRIMARY KEY (id, torneo);
ALTER TABLE Clasificaciones ADD CONSTRAINT pk_clasificaciones PRIMARY KEY (id, torneo);
ALTER TABLE Practicas ADD CONSTRAINT pk_practicas PRIMARY KEY (id, torneo);
ALTER TABLE Juegos ADD CONSTRAINT pk_juegos PRIMARY KEY (nombre);
ALTER TABLE Circuitos ADD CONSTRAINT pk_circuitos PRIMARY KEY (nombre);
ALTER TABLE Vehiculos ADD CONSTRAINT pk_vehiculos PRIMARY KEY (marca, referencia);
ALTER TABLE Organizadores ADD CONSTRAINT pk_organizadores PRIMARY KEY (id);
ALTER TABLE Usuarios ADD CONSTRAINT pk_usuarios PRIMARY KEY (id);
ALTER TABLE CircuitosDisponibles ADD CONSTRAINT pk_circuitosdisponibles PRIMARY KEY (juego, circuito, clima);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT pk_vehiculosdejuegos PRIMARY KEY (juego, marca_vehiculo, referencia_vehiculo);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT pk_vehiculosportorneo PRIMARY KEY (torneo, marca_vehiculo, referencia_vehiculo);

-- Llaves unicas
ALTER TABLE Usuarios ADD CONSTRAINT uk_usuarios_nombre_usuario UNIQUE (nombre_usuario);
ALTER TABLE Usuarios ADD CONSTRAINT uk_usuarios_correo UNIQUE (correo);

-- Llaves foraneas
ALTER TABLE Organizadores ADD CONSTRAINT fk_organizadores_usuarios FOREIGN KEY (id) REFERENCES Usuarios(id);
ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_organizadores FOREIGN KEY (organizador) REFERENCES Organizadores(id);
ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id);
ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre);
ALTER TABLE CircuitosDisponibles ADD CONSTRAINT fk_circuitosdisponibles_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE CircuitosDisponibles ADD CONSTRAINT fk_circuitosdisponibles_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehiculo) REFERENCES Vehiculos(marca, referencia);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehiculo) REFERENCES Vehiculos(marca, referencia);
ALTER TABLE Carreras ADD CONSTRAINT fk_carreras_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo);
ALTER TABLE Clasificaciones ADD CONSTRAINT fk_clasificaciones_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo);
ALTER TABLE Practicas ADD CONSTRAINT fk_practicas_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo);

-- PoblarOk
INSERT INTO Juegos (nombre) VALUES ('Gran Turismo 7');
INSERT INTO Juegos (nombre) VALUES ('F1 2025');
INSERT INTO Juegos (nombre) VALUES ('Assetto Corsa');

INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('Spa-Francorchamps', 'Bélgica', 7.004);
INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('Monza', 'Italia', 5.793);
INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('Silverstone', 'Reino Unido', 5.891);

INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('Ferrari', '488 GTB', 2015, 'Deportivo', 1475.00, 660);
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('Porsche', '911 GT3 RS', 2020, 'Deportivo', 1430.00, 520);
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('BMW', 'E46', 2003, 'Calle', 1655.00, 168);
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('Red Bull', 'RB21', 2025, 'Monoplaza', NULL, NULL);

INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('Gran Turismo 7', 'Spa-Francorchamps', 'Despejado');
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('F1 2025', 'Monza', 'Despejado');
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('F1 2025', 'Monza', 'Lluvia ligera');
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('Assetto Corsa', 'Silverstone', 'Nublado');

INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('Gran Turismo 7', 'Ferrari', '488 GTB');
INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('F1 2025', 'Red Bull', 'RB21');
INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('Assetto Corsa', 'Porsche', '911 GT3 RS');

INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('RAC0000000', 'RacerX', 'racerx@example.com', 'España', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('SPE0000000', 'Speedy', 'speedy@example.com', 'Francia', TO_DATE('2023-01-02', 'YYYY-MM-DD'));
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('SPE0000001', 'Speeder', 'speeder@example.com', 'Italia', TO_DATE('2023-01-03', 'YYYY-MM-DD'));

INSERT INTO Organizadores (id, total_torneos_creados) VALUES ('RAC0000000', 0);
INSERT INTO Organizadores (id, total_torneos_creados) VALUES ('SPE0000000', 0);

INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('RAC00000000000000000', 'Eurocup', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-06-07', 'YYYY-MM-DD'), 20, 'PC', 'Programado', 'RAC0000000', 'F1 2025');
INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('SPE00000000000000000', 'GT Championship', TO_DATE('2023-07-05', 'YYYY-MM-DD'), TO_DATE('2023-07-06', 'YYYY-MM-DD'), 15, 'PlayStation', 'Programado', 'SPE0000000', 'Gran Turismo 7');

INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('RAC00000000000000000', 'Red Bull', 'RB21');
INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('SPE00000000000000000', 'Ferrari', '488 GTB');
INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('SPE00000000000000000', 'Porsche', '911 GT3 RS');

INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (0, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'RAC00000000000000000', 'Monza');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (1, TO_DATE('2023-06-06 20:00', 'YYYY-MM-DD HH24:MI'), 'Lluvia ligera', '12:00', 'Programado', 'RAC00000000000000000', 'Spa-Francorchamps');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (2, TO_DATE('2023-06-07 20:00', 'YYYY-MM-DD HH24:MI'), 'Nublado', '16:30', 'Programado', 'RAC00000000000000000', 'Silverstone');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (0, TO_DATE('2023-07-05 13:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '09:00', 'Programado', 'SPE00000000000000000', 'Spa-Francorchamps');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (1, TO_DATE('2023-07-05 15:30', 'YYYY-MM-DD HH24:MI'), 'Despejado', '10:00', 'Programado', 'SPE00000000000000000', 'Spa-Francorchamps');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (2, TO_DATE('2023-07-05 16:30', 'YYYY-MM-DD HH24:MI'), 'Despejado', '15:00', 'Programado', 'SPE00000000000000000', 'Spa-Francorchamps');

INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (0, 'RAC00000000000000000', 30);
INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (1, 'RAC00000000000000000', 25);
INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (2, 'RAC00000000000000000', 50);
INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (2, 'SPE00000000000000000', 20);

INSERT INTO Clasificaciones (id, torneo, duracion) VALUES (1, 'SPE00000000000000000', '00:30');

INSERT INTO Practicas (id, torneo, duracion) VALUES (0, 'SPE00000000000000000', '01:00');

-- PoblarNoOk

-- El ID es demasiado corto.
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('INVALIDID', 'ValidUser', 'validemail@a.com', 'Nowhere', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
-- El correo electrónico no es válido.
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('VALIDID001', 'ValidUser', 'invalidemail', 'Nowhere', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
-- El nombre de usuario contiene espacios.
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('VALIDID002', 'Invalid User', 'validemail@a.com', 'Nowhere', TO_DATE('2023-01-01', 'YYYY-MM-DD'));

-- El Usuario no existe.
INSERT INTO Organizadores (id, total_torneos_creados) VALUES ('AAA0000020', 0);

-- El organizador no existe.
INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('VALIDTOURNEY001', 'Valid Tournament', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-06-15', 'YYYY-MM-DD'), 10, 'PC', 'Programado', 'AAA0000020', 'F1 2025');

-- El torneo tiene un cupo inválido.
INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('INVALIDTOURNEY', 'Bad Tournament', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-06-15', 'YYYY-MM-DD'), -1, 'PC', 'Programado', 'RAC0000000', 'F1 2025');

-- La fecha del evento es inválida.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (99, TO_DATE('2023-06-05 00:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'RAC00000000000000000', 'Monza');
-- El clima del evento es inválido.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (99, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Tormenta', '14:00', 'Programado', 'RAC00000000000000000', 'Monza');
-- El circuito no existe.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (99, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'RAC00000000000000000', 'Circuito Inexistente');
-- No se da el torneo.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, circuito) VALUES (99, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'Monza');   

-- La duración de la clasificación es inválida.
INSERT INTO Clasificaciones (id, torneo, duracion) VALUES (99, 'SPE00000000000000000', '25:00');

-- La duración de la práctica es inválida.
INSERT INTO Practicas (id, torneo, duracion) VALUES (99, 'SPE00000000000000000', '01:60');

-- El vehículo no existe.
INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('SPE00000000000000000', 'MarcaInexistente', 'ReferenciaInexistente');

-- El juego no existe.
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('JuegoInexistente', 'Spa-Francorchamps', 'Despejado');

-- El circuito no existe.
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('F1 2025', 'CircuitoInexistente', 'Despejado');

-- El vehículo no existe.
INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('F1 2025', 'MarcaInexistente', 'ReferenciaInexistente');

-- nombre del juego es demasiado largo.
INSERT INTO Juegos (nombre) VALUES ('EsteNombreDeJuegoEsDemasiadoLargoParaSerValido');

-- La longitud del circuito es inválida.
INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('CircuitoValido', 'PaisValido', -5.0);

-- El peso del vehículo es inválido.
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('MarcaValida', 'ReferenciaValida', 2020, 'Deportivo', -1500.00, 300);



-- Consultas
-- 1. Listar todos los torneos programados
SELECT * FROM Torneos WHERE estado = 'Programado';

-- 2. Listar todos los torneos organizados por un organizador específico
SELECT * FROM Torneos WHERE organizador = 'RAC0000000';

-- 3. Listar todas las carreras de un torneo específico
SELECT * FROM Carreras WHERE torneo = 'RAC00000000000000000';

-- 4. Listar todas las clasificaciones de un torneo específico
SELECT * FROM Clasificaciones WHERE torneo = 'SPE00000000000000000';

-- 5. Listar todas las prácticas de un torneo específico
SELECT * FROM Practicas WHERE torneo = 'SPE00000000000000000';

-- 6. Listar todos los eventos de un torneo específico
SELECT * FROM Eventos WHERE torneo = 'RAC00000000000000000';

-- 7. Listar todos los vehículos disponibles para un torneo específico
SELECT v.* FROM Vehiculos v
JOIN VehiculosPorTorneo vt ON v.marca = vt.marca_vehiculo AND v.referencia = vt.referencia_vehiculo
WHERE vt.torneo = 'SPE00000000000000000';

-- 8. Listar todos los circuitos disponibles para un juego específico
SELECT cd.* FROM CircuitosDisponibles cd
WHERE cd.juego = 'F1 2025';

-- 9. Listar todos los vehículos disponibles en un juego específico
SELECT v.* FROM Vehiculos v
JOIN VehiculosDeJuegos vd ON v.marca = vd.marca_vehiculo AND v.referencia = vd.referencia_vehiculo
WHERE vd.juego = 'Assetto Corsa';

-- XPoblar
DELETE FROM Carreras;
DELETE FROM Clasificaciones;
DELETE FROM Practicas;
DELETE FROM Eventos;
DELETE FROM VehiculosPorTorneo;
DELETE FROM VehiculosDeJuegos;
DELETE FROM CircuitosDisponibles;
DELETE FROM Torneos;
DELETE FROM Organizadores;
DELETE FROM Juegos;
DELETE FROM Circuitos;
DELETE FROM Vehiculos;
DELETE FROM Usuarios;



-- XTablas
DROP TABLE Carreras CASCADE CONSTRAINTS;
DROP TABLE Clasificaciones CASCADE CONSTRAINTS;
DROP TABLE Practicas CASCADE CONSTRAINTS;
DROP TABLE Eventos CASCADE CONSTRAINTS;
DROP TABLE VehiculosPorTorneo CASCADE CONSTRAINTS;
DROP TABLE VehiculosDeJuegos CASCADE CONSTRAINTS;
DROP TABLE CircuitosDisponibles CASCADE CONSTRAINTS;
DROP TABLE Torneos CASCADE CONSTRAINTS;
DROP TABLE Organizadores CASCADE CONSTRAINTS;
DROP TABLE Juegos CASCADE CONSTRAINTS;
DROP TABLE Circuitos CASCADE CONSTRAINTS;
DROP TABLE Vehiculos CASCADE CONSTRAINTS;
DROP TABLE Usuarios CASCADE CONSTRAINTS;