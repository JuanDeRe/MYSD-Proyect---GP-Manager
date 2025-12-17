/**
 * PACKAGE: pk_jugador
CREATE OR REPLACE PACKAGE BODY pk_jugador AS

    PROCEDURE jugadorAdicionar(nombre_usuario VARCHAR2, correo VARCHAR2, pais VARCHAR2) IS
    BEGIN
        PK_MANTENER_JUGADOR.JugadorAdicionar(nombre_usuario, correo, pais);
    END jugadorAdicionar;
    
    PROCEDURE jugadorModificar(nombre_usuario VARCHAR2, correo VARCHAR2, pais VARCHAR2) IS
    BEGIN
        PK_MANTENER_JUGADOR.JugadorModificar(nombre_usuario, correo, pais);
    END jugadorModificar;
    
    PROCEDURE inscripcionAdicionar(jugador VARCHAR2, torneo VARCHAR2, juego VARCHAR2, marca_vehiculo VARCHAR2, referencia_vehiculo VARCHAR2, fecha DATE DEFAULT NULL) IS
    BEGIN
        PK_REGISTRAR_INSCRIPCION.InscripcionAdicionar(jugador, torneo, juego, marca_vehiculo, referencia_vehiculo, fecha);
    END inscripcionAdicionar;
    
    FUNCTION consultarTorneosDisponibles RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT torneo_id, torneo_nombre, juego, fecha_inicio, fecha_fin,
                   cupo, estado, organizador, inscritos_actuales
            FROM v_torneos_disponibles;
        RETURN v_cursor;
    END consultarTorneosDisponibles;
    
    FUNCTION consultarInscripcionesPropias(p_jugador_id VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT torneo_nombre, juego, fecha_inscripcion, estado_inscripcion, 
                   marca, referencia, fecha_inicio
            FROM v_inscripciones_propias
            WHERE jugador = p_jugador_id;
        RETURN v_cursor;
    END consultarInscripcionesPropias;
    
    FUNCTION consultarRankingPropio(p_torneo_id VARCHAR2, p_jugador_id VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT torneo_nombre, posicion, puntos_totales, rango, estado_torneo
            FROM v_ranking_jugador
            WHERE torneo = p_torneo_id
              AND jugador = p_jugador_id;
        RETURN v_cursor;
    END consultarRankingPropio;
    
    FUNCTION consultarResultadosPropios(p_torneo_id VARCHAR2, p_jugador_id VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT torneo_nombre, fecha_evento, circuito, tipo_evento,
                   posicion_inicio, posicion_final, mejor_vuelta, tiempo_total,
                   puntos_obtenidos, estado_resultado
            FROM v_resultados_jugador
            WHERE torneo = p_torneo_id
              AND jugador = p_jugador_id;
        RETURN v_cursor;
    END consultarResultadosPropios;
    
    FUNCTION consultarMejoresVueltasCircuito (p_circuito VARCHAR2, p_clima VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT circuito, circuito_pais, circuito_longitud, 
                   record_vuelta, record_jugador, fecha_record
            FROM v_mejores_vueltas_circuito
            WHERE circuito = p_circuito
              AND circuito_clima = p_clima;
        RETURN v_cursor;
    END consultarMejoresVueltasCircuito;
    
END pk_jugador;
/


CREATE OR REPLACE PACKAGE BODY pk_organizador AS

    PROCEDURE inscripcionModificar(jugador VARCHAR2, torneo VARCHAR2, juego VARCHAR2, estado VARCHAR2) IS
    BEGIN
        PK_MANTENER_INSCRIPCION.InscripcionModificar(jugador, torneo, juego, estado);
    END inscripcionModificar;
    
    PROCEDURE resultadoAdicionar(jugador VARCHAR2, evento NUMBER, torneo VARCHAR2, juego VARCHAR2, estado_resultado VARCHAR2, posicion_inicio NUMBER, posicion_final NUMBER, tiempo_total NUMBER, mejor_vuelta NUMBER, puntos_obtenidos NUMBER) IS
    BEGIN
        PK_REGISTRAR_RESULTADO.ResultadoAdicionar(jugador, evento, torneo, juego, estado_resultado, posicion_inicio, posicion_final, tiempo_total, mejor_vuelta, puntos_obtenidos);
    END resultadoAdicionar;
    
    FUNCTION consultarInscripcionesPendientes(p_torneo_id VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        IF p_torneo_id IS NULL THEN
            OPEN v_cursor FOR
                SELECT torneo_nombre, jugador_nombre, jugador_rango, eventos_finalizados,
                       marca, referencia, fecha_inscripcion
                FROM v_inscripciones_pendientes;
        ELSE
            OPEN v_cursor FOR
                SELECT torneo_nombre, jugador_nombre, jugador_rango, eventos_finalizados,
                       marca, referencia, fecha_inscripcion
                FROM v_inscripciones_pendientes
                WHERE torneo = p_torneo_id;
        END IF;
        RETURN v_cursor;
    END consultarInscripcionesPendientes;
    
    FUNCTION consultarJugadoresConfirmados(p_torneo_id VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT torneo_nombre, estado_torneo, jugador_nombre, jugador_rango,
                   experiencia, vehiculo_inscrito, fecha_inscripcion
            FROM v_jugadores_confirmados
            WHERE torneo = p_torneo_id;
        RETURN v_cursor;
    END consultarJugadoresConfirmados;
    
    FUNCTION consultarTop3Finalizados (p_torneo_id VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT torneo_nombre, fecha_inicio, juego, posicion, jugador, rango, puntos_totales
            FROM v_top3_torneos_finalizados
            WHERE torneo = p_torneo_id;
        RETURN v_cursor;
    END consultarTop3Finalizados;
    
    FUNCTION consultarMejoresVueltasCircuito (p_circuito VARCHAR2, p_clima VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT circuito, circuito_pais, circuito_longitud, 
                   record_vuelta, record_jugador, fecha_record
            FROM v_mejores_vueltas_circuito
            WHERE circuito = p_circuito
              AND circuito_clima = p_clima;
        RETURN v_cursor;
    END consultarMejoresVueltasCircuito;
    
END pk_organizador;
/