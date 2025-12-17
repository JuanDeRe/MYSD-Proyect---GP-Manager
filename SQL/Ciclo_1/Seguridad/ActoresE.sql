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
    PROCEDURE inscripcionModificar(jugador VARCHAR2, torneo VARCHAR2, juego VARCHAR2, estado VARCHAR2);
    PROCEDURE resultadoAdicionar(jugador VARCHAR2, evento NUMBER, torneo VARCHAR2, juego VARCHAR2, estado_resultado VARCHAR2, posicion_inicio NUMBER, posicion_final NUMBER, tiempo_total NUMBER, mejor_vuelta NUMBER, puntos_obtenidos NUMBER);
    FUNCTION consultarInscripcionesPendientes (p_torneo_id VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarJugadoresConfirmados (p_torneo_id VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarTop3Finalizados (p_torneo_id VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarMejoresVueltasCircuito (p_circuito VARCHAR2, p_clima VARCHAR2) RETURN SYS_REFCURSOR;
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
    PROCEDURE jugadorAdicionar(nombre_usuario VARCHAR2, correo VARCHAR2, pais VARCHAR2);
    PROCEDURE jugadorModificar(nombre_usuario VARCHAR2, correo VARCHAR2, pais VARCHAR2);
    PROCEDURE inscripcionAdicionar(jugador VARCHAR2, torneo VARCHAR2, juego VARCHAR2, marca_vehiculo VARCHAR2, referencia_vehiculo VARCHAR2, fecha DATE DEFAULT NULL);
    FUNCTION consultarTorneosDisponibles RETURN SYS_REFCURSOR;
    FUNCTION consultarInscripcionesPropias(p_jugador_id VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarRankingPropio(p_torneo_id VARCHAR2, p_jugador_id VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarResultadosPropios(p_torneo_id VARCHAR2, p_jugador_id VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarMejoresVueltasCircuito (p_circuito VARCHAR2, p_clima VARCHAR2) RETURN SYS_REFCURSOR;
END pk_jugador;
/