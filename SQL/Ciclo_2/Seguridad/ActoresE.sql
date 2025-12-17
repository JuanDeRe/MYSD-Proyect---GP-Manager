/*
CREATE OR REPLACE PACKAGE pk_jugador IS
    PROCEDURE jugadorAdicionar(nombre_usuario VARCHAR2, correo VARCHAR2, pais VARCHAR2);
    PROCEDURE jugadorModificar(nombre_usuario VARCHAR2, correo VARCHAR2, pais VARCHAR2);
    PROCEDURE inscripcionAdicionar(jugador VARCHAR2, torneo VARCHAR2, juego VARCHAR2, marca_vehiculo VARCHAR2, referencia_vehiculo VARCHAR2, fecha DATE DEFAULT SYSDATE);
    FUNCTION consultarTorneosDisponibles RETURN SYS_REFCURSOR;
    FUNCTION consultarInscripcionesPropias(jugador VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarRankingPropio(torneo VARCHAR2, jugador VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarResultadosPropios(torneo VARCHAR2, jugador VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarMejoresVueltasCircuito (circuito VARCHAR2, clima VARCHAR2) RETURN SYS_REFCURSOR;
END pk_jugador;
/

CREATE OR REPLACE PACKAGE pk_organizador IS
    PROCEDURE inscripcionModificar(jugador VARCHAR2, torneo VARCHAR2, juego VARCHAR2, estado VARCHAR2);
    PROCEDURE resultadoAdicionar(jugador VARCHAR2, evento NUMBER, torneo VARCHAR2, juego VARCHAR2, estado_resultado VARCHAR2, posicion_inicio NUMBER, posicion_final NUMBER, tiempo_total NUMBER, mejor_vuelta NUMBER, puntos_obtenidos NUMBER);
    FUNCTION consultarInscripcionesPendientes (torneo VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarJugadoresConfirmados (torneo VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarTop3Finalizados (torneo VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION consultarMejoresVueltasCircuito (circuito VARCHAR2, clima VARCHAR2) RETURN SYS_REFCURSOR;
END pk_organizador;
/