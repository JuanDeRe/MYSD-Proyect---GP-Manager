CREATE TABLE Jugadores (
    id VARCHAR2(10) NOT NULL,
    ranking_global NUMBER NOT NULL
);

CREATE TABLE Inscripciones (
    jugador VARCHAR2(10) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    marca_vehiculo VARCHAR2(15) NOT NULL,
    referencia_vehiculo VARCHAR2(30) NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR2(20) NOT NULL
);

CREATE TABLE Rankings (
    jugador VARCHAR2(10) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    posicion NUMBER(3),
    puntos_totales NUMBER(4) NOT NULL
);

CREATE TABLE Resultados (
    jugador VARCHAR2(10) NOT NULL,
    torneo VARCHAR2(20) NOT NULL,
    evento NUMBER(4) NOT NULL,
    posicion_final NUMBER(3) NOT NULL,
    posicion_inicial NUMBER(3) NOT NULL,
    tiempo_total NUMBER(6) NOT NULL,
    mejor_vuelta NUMBER(7) NOT NULL,
    puntos_obtenidos NUMBER(3) NOT NULL,
    estado_resultado VARCHAR2(20) NOT NULL
);