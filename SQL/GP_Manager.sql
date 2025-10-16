-- Tablas
CREATE TABLE Torneos(
    id VARCHAR2(20) NOT NULL,
    nombre VARCHAR2(40) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    cupo NUMBER(3) NOT NULL,
    plataforma_principal VARCHAR2(15) NOT NULL,
    organizador VARCHAR2(8) NOT NULL,
    juego VARCHAR2(20) NOT NULL
);

CREATE TABLE Eventos(
    id VARCHAR2(20) NOT NULL,
    fecha DATE NOT NULL,
    clima VARCHAR2(20) NOT NULL,
    hora_in_game VARCHAR2(5) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    circuito VARCHAR2(40) NOT NULL
);

CREATE TABLE Carreras(
    id VARCHAR2(20) NOT NULL,
    numero_vueltas NUMBER(3) NOT NULL
);

CREATE TABLE Clasificaciones(
    id VARCHAR2(20) NOT NULL,
    duracion VARCHAR2(5) NOT NULL
);

CREATE TABLE Practicas (
    id VARCHAR2(20) NOT NULL,
    duracion VARCHAR2(5) NOT NULL
);

CREATE TABLE Juegos (
    nombre VARCHAR2(20) NOT NULL
);

CREATE TABLE CircuitosDeJuegos(
    juego VARCHAR2(20),
    circuito VARCHAR2(40)
);

CREATE TABLE Circuitos(
    nombre VARCHAR2(40) NOT NULL,
    pais VARCHAR2(10) NOT NULL,
    longitud NUMBER(4,2) NOT NULL
);

CREATE TABLE VehiculosDeJuegos(
    juego VARCHAR2(20) NOT NULL,
    marca_vehiculo VARCHAR2(15) NOT NULL,
    referencia_vehuiculo VARCHAR2(30) NOT NULL
);

CREATE TABLE VehiculosPorTorneo(
    torneo VARCHAR2(20) NOT NULL,
    marca_vehiculo VARCHAR2(15) NOT NULL,
    referencia_vehuiculo VARCHAR2(30) NOT NULL
);

CREATE TABLE Vehiculos(
    marca VARCHAR2(15) NOT NULL,
    referencia VARCHAR2(30) NOT NULL,
    año NUMBER(4) NOT NULL,
    categoria VARCHAR2(20),
    peso NUMBER(4),
    hp NUMBER(4)
);

CREATE TABLE Organizadores(
    id VARCHAR2(8) NOT NULL,
    torneos_creados NUMBER(6)
);

CREATE TABLE Usuarios(
    id VARCHAR2(8) NOT NULL,
    nombre_usuario VARCHAR2(15) NOT NULL,
    correo VARCHAR2(80),
    pais VARCHAR2(10) NOT NULL
);

-- Llaves primarias
ALTER TABLE Torneos ADD CONSTRAINT pk_torneos PRIMARY KEY (id);
ALTER TABLE Eventos ADD CONSTRAINT pk_eventos PRIMARY KEY (id); 
ALTER TABLE Carreras ADD CONSTRAINT pk_carreras PRIMARY KEY (id);
ALTER TABLE Clasificaciones ADD CONSTRAINT pk_clasificaciones PRIMARY KEY (id);
ALTER TABLE Practicas ADD CONSTRAINT pk_practicas PRIMARY KEY (id);
ALTER TABLE Juegos ADD CONSTRAINT pk_juegos PRIMARY KEY (nombre);
ALTER TABLE Circuitos ADD CONSTRAINT pk_circuitos PRIMARY KEY (nombre);
ALTER TABLE Vehiculos ADD CONSTRAINT pk_vehiculos PRIMARY KEY (marca, referencia);
ALTER TABLE Organizadores ADD CONSTRAINT pk_organizadores PRIMARY KEY (id);
ALTER TABLE Usuarios ADD CONSTRAINT pk_usuarios PRIMARY KEY (id);
ALTER TABLE CircuitosDeJuegos ADD CONSTRAINT pk_circuitosdejuegos PRIMARY KEY (juego, circuito);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT pk_vehiculosdejuegos PRIMARY KEY (juego, marca_vehiculo, referencia_vehuiculo);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT pk_vehiculosportorneo PRIMARY KEY (torneo, marca_vehiculo, referencia_vehuiculo);

-- Llaves unicas
ALTER TABLE Usuarios ADD CONSTRAINT uq_usuarios_nombre_usuario UNIQUE (nombre_usuario);
ALTER TABLE Usuarios ADD CONSTRAINT uq_usuarios_correo UNIQUE (correo);

-- Llaves foraneas
ALTER TABLE Organizadores ADD CONSTRAINT fk_organizadores_usuarios FOREIGN KEY (id) REFERENCES Usuarios(id);
ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_organizadores FOREIGN KEY (organizador) REFERENCES Organizadores(id);
ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id);
ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre);
ALTER TABLE CircuitosDeJuegos ADD CONSTRAINT fk_circuitosdejuegos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE CircuitosDeJuegos ADD CONSTRAINT fk_circuitosdejuegos_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehuiculo) REFERENCES Vehiculos(marca, referencia);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehuiculo) REFERENCES Vehiculos(marca, referencia);
ALTER TABLE Carreras ADD CONSTRAINT fk_carreras_eventos FOREIGN KEY (id) REFERENCES Eventos(id);
ALTER TABLE Clasificaciones ADD CONSTRAINT fk_clasificaciones_eventos FOREIGN KEY (id) REFERENCES Eventos(id);
ALTER TABLE Practicas ADD CONSTRAINT fk_practicas_eventos FOREIGN KEY (id) REFERENCES Eventos(id);

-- Atributos
ALTER TABLE Torneos
ADD CONSTRAINT chk_torneos_plataforma CHECK (plataforma_principal IN ('PC', 'Xbox', 'PlayStation', 'Nintendo', 'Multiplataforma'));
ALTER TABLE Eventos
ADD CONSTRAINT chk_eventos_clima CHECK (clima IN ('Despejado', 'Nublado', 'Lluvia ligera', 'Lluvia fuerte', 'Dinamico'))
ADD CONSTRAINT chk_eventos_hora_in_game CHECK (REGEXP_LIKE(hora_in_game, '^([01][0-9]|2[0-3]):[0-5][0-9]$'));

-- XTablas
DROP TABLE Carreras CASCADE CONSTRAINTS;
DROP TABLE Clasificaciones CASCADE CONSTRAINTS;
DROP TABLE Practicas CASCADE CONSTRAINTS;
DROP TABLE Eventos CASCADE CONSTRAINTS;
DROP TABLE VehiculosPorTorneo CASCADE CONSTRAINTS;
DROP TABLE VehiculosDeJuegos CASCADE CONSTRAINTS;
DROP TABLE CircuitosDeJuegos CASCADE CONSTRAINTS;
DROP TABLE Torneos CASCADE CONSTRAINTS;
DROP TABLE Organizadores CASCADE CONSTRAINTS;
DROP TABLE Juegos CASCADE CONSTRAINTS;
DROP TABLE Circuitos CASCADE CONSTRAINTS;
DROP TABLE Vehiculos CASCADE CONSTRAINTS;
DROP TABLE Usuarios CASCADE CONSTRAINTS;
