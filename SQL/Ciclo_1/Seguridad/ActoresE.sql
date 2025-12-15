CREATE OR REPLACE PACKAGE pk_organizador IS
    PROCEDURE organizadorAdicionar(nombre_usuario VARCHAR, pais VARCHAR, correo VARCHAR);
    PROCEDURE organizadorModificar(nombre_usuario VARCHAR, correo VARCHAR, pais VARCHAR);
    PROCEDURE organizadorEliminar(nombre_usuario VARCHAR);
    PROCEDURE torneoAdicionar(nombre VARCHAR, fecha_inicio DATE, fecha_fin DATE, cupo NUMBER, plataforma_principal VARCHAR, juego VARCHAR, organizador VARCHAR);
    PROCEDURE torneoModificar(nombre VARCHAR, juego VARCHAR, cupo NUMBER, estado VARCHAR);
    PROCEDURE eventoAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR);
    PROCEDURE eventoModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR);
    PROCEDURE carreraAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, numero_vueltas NUMBER);
    PROCEDURE carreraModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, numero_vueltas NUMBER);
    PROCEDURE clasificacionAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR);
    PROCEDURE clasificacionModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR);
    PROCEDURE practicaAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR);
    PROCEDURE practicaModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR);
    FUNCTION consultarVehiculosTorneo(id VARCHAR) RETURN SYS_REFCURSOR;
    FUNCTION consultarCircuitosTorneo(id VARCHAR) RETURN SYS_REFCURSOR;
    FUNCTION consultarDetallesTorneo(id VARCHAR) RETURN SYS_REFCURSOR;
END pk_organizador;
/

CREATE OR REPLACE PACKAGE pk_desarrollador IS
    PROCEDURE vehiculoAdicionar(marca VARCHAR, referencia VARCHAR, a_o NUMBER, categoria VARCHAR, peso NUMBER, hp NUMBER, juego VARCHAR);
    PROCEDURE vehiculoEliminar(marca VARCHAR, referencia VARCHAR, juego VARCHAR);
    PROCEDURE circuitoAdicionar(nombre VARCHAR, pais VARCHAR, longitud NUMBER, juego VARCHAR, clima VARCHAR);
    PROCEDURE circuitoEliminar(nombre VARCHAR, juego VARCHAR, clima VARCHAR);
    PROCEDURE juegoAdicionar(nombre VARCHAR);
    PROCEDURE juegoEliminar(nombre VARCHAR);
    PROCEDURE organizadorEliminar(nombre_usuario VARCHAR);
END pk_desarrollador;
/

CREATE OR REPLACE PACKAGE pk_jugador IS
    FUNCTION consultarEventosTorneo(id VARCHAR) RETURN SYS_REFCURSOR;
    FUNCTION consultarVehiculosJuego(nombre_juego VARCHAR) RETURN SYS_REFCURSOR;
    FUNCTION consultarCircuitosJuego(nombre_juego VARCHAR) RETURN SYS_REFCURSOR;
    FUNCTION consultarDetallesTorneo(id VARCHAR) RETURN SYS_REFCURSOR;
END pk_jugador;
/