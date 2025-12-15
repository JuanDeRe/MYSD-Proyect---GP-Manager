--Tablas y Atributos
CREATE TABLE Torneos (
    id VARCHAR2(20) NOT NULL,
    nombre VARCHAR2(40) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    cupo NUMBER(3) NOT NULL,
    plataforma_principal VARCHAR2(15) NOT NULL,
    estado VARCHAR2(15) NOT NULL,
    numero_eventos NUMBER(4) NOT NULL,
    organizador VARCHAR2(10) NOT NULL,
    juego VARCHAR2(20) NOT NULL
);

CREATE TABLE Eventos (
    id NUMBER(4) NOT NULL,
    fecha DATE NOT NULL,
    clima VARCHAR2(20) NOT NULL,
    hora_in_game VARCHAR2(5) NOT NULL,
    estado VARCHAR2(15) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    circuito VARCHAR2(40) NOT NULL
);

CREATE TABLE Carreras (
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

CREATE TABLE Circuitos (
    nombre VARCHAR2(40) NOT NULL,
    pais VARCHAR2(20) NOT NULL,
    longitud NUMBER(6,2) NOT NULL
);

CREATE TABLE CircuitosDisponibles (
    juego VARCHAR2(20) NOT NULL,
    circuito VARCHAR2(40) NOT NULL,
    clima VARCHAR2(20) NOT NULL
);

CREATE TABLE VehiculosDeJuegos (
    juego VARCHAR2(20) NOT NULL,
    marca_vehiculo VARCHAR2(15) NOT NULL,
    referencia_vehiculo VARCHAR2(30) NOT NULL
);

CREATE TABLE VehiculosPorTorneo (
    torneo VARCHAR2(20) NOT NULL,
    marca_vehiculo VARCHAR2(15) NOT NULL,
    referencia_vehiculo VARCHAR2(30) NOT NULL
);

CREATE TABLE Vehiculos (
    marca VARCHAR2(15) NOT NULL,
    referencia VARCHAR2(30) NOT NULL,
    año NUMBER(4) NOT NULL,
    categoria VARCHAR2(20),
    peso NUMBER(6,2),
    hp NUMBER(4)
);

CREATE TABLE Organizadores (
    id VARCHAR2(10) NOT NULL,
    total_torneos_creados NUMBER(6)
);

CREATE TABLE Usuarios (
    id VARCHAR2(10) NOT NULL,
    nombre_usuario VARCHAR2(15) NOT NULL,
    correo VARCHAR2(80),
    pais VARCHAR2(20) NOT NULL,
    fecha_registro DATE NOT NULL
);