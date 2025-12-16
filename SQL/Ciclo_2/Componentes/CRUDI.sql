CREATE OR REPLACE PACKAGE BODY PK_MANTENER_JUGADOR AS

    PROCEDURE JugadorAdicionar(
        p_nombre_usuario IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_pais IN VARCHAR2
    ) IS
    v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Usuarios WHERE nombre_usuario = p_nombre_usuario;
        IF v_count = 0 THEN
            INSERT INTO Usuarios (nombre_usuario, correo, pais)
            VALUES (p_nombre_usuario, p_correo, p_pais);
        END IF;
        INSERT INTO Jugadores (id)
        VALUES ((SELECT id FROM Usuarios WHERE nombre_usuario = p_nombre_usuario));
        
        COMMIT; 
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE; 
    END JugadorAdicionar;

    PROCEDURE JugadorModificar(
        p_nombre_usuario IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_pais IN VARCHAR2
    ) IS
    v_id_usuario VARCHAR2(100);
    BEGIN
        SELECT id INTO v_id_usuario FROM Usuarios WHERE nombre_usuario = p_nombre_usuario;
        UPDATE Usuarios
        SET pais = p_pais,
            correo = p_correo
        WHERE id = v_id_usuario;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END JugadorModificar;

    PROCEDURE JugadorEliminar(
        p_nombre_usuario IN VARCHAR2
    ) IS
    v_id_usuario VARCHAR2(100);
    BEGIN
        SELECT id INTO v_id_usuario FROM Usuarios WHERE nombre_usuario = p_nombre_usuario;
        DELETE FROM Jugadores WHERE id = v_id_usuario;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END JugadorEliminar;

END PK_MANTENER_JUGADOR;
/

CREATE OR REPLACE PACKAGE BODY PK_REGISTRAR_INSCRIPCION AS
    PROCEDURE InscripcionAdicionar (
        p_jugador IN VARCHAR2,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2,
        p_fecha IN DATE DEFAULT NULL
    ) IS
    v_id_usuario VARCHAR2(100);
    v_id_torneo VARCHAR2(100);
    BEGIN
        SELECT jugadores.id INTO v_id_usuario FROM Jugadores
        JOIN Usuarios ON Jugadores.id = Usuarios.id
        WHERE usuarios.nombre_usuario = p_jugador;
        SELECT id INTO v_id_torneo FROM Torneos WHERE nombre = p_torneo AND juego = p_juego;
        INSERT INTO Inscripciones (jugador, torneo, marca_vehiculo, referencia_vehiculo, fecha)
        VALUES (v_id_usuario, v_id_torneo, p_marca_vehiculo, p_referencia_vehiculo, p_fecha);
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END InscripcionAdicionar;
END PK_REGISTRAR_INSCRIPCION;
/

CREATE OR REPLACE PACKAGE BODY PK_MANTENER_INSCRIPCION AS
    PROCEDURE InscripcionModificar(
        p_jugador IN VARCHAR2,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_estado IN VARCHAR2
    ) IS
    v_id_usuario VARCHAR2(100);
    v_id_torneo VARCHAR2(100);
    BEGIN
        SELECT jugadores.id INTO v_id_usuario FROM Jugadores 
        JOIN Usuarios ON Jugadores.id = Usuarios.id
        WHERE usuarios.nombre_usuario = p_jugador;
        SELECT id INTO v_id_torneo FROM Torneos 
        WHERE nombre = p_torneo AND juego = p_juego;
        UPDATE Inscripciones
        SET estado = p_estado
        WHERE jugador = v_id_usuario AND torneo = v_id_torneo;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END InscripcionModificar;
END PK_MANTENER_INSCRIPCION;
/

CREATE OR REPLACE PACKAGE BODY PK_REGISTRAR_RESULTADO AS
    PROCEDURE ResultadoAdicionar(
        p_jugador IN VARCHAR2,
        p_evento IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_estado_resultado IN VARCHAR2,
        p_posicion_inicio IN NUMBER,
        p_posicion_final IN NUMBER,
        p_tiempo_total IN NUMBER,
        p_mejor_vuelta IN NUMBER,
        p_puntos_obtenidos IN NUMBER
    ) IS
    v_id_usuario VARCHAR2(100);
    v_id_torneo VARCHAR2(100);
    BEGIN
        SELECT jugadores.id INTO v_id_usuario FROM Jugadores 
        JOIN Usuarios ON Jugadores.id = Usuarios.id
        WHERE usuarios.nombre_usuario = p_jugador;
        SELECT id INTO v_id_torneo FROM Torneos 
        WHERE nombre = p_torneo AND juego = p_juego;
        INSERT INTO Resultados (jugador, evento, torneo, estado_resultado, posicion_inicio, posicion_final, tiempo_total, mejor_vuelta, puntos_obtenidos)
        VALUES (v_id_usuario, p_evento, v_id_torneo, p_estado_resultado, p_posicion_inicio, p_posicion_final, p_tiempo_total, p_mejor_vuelta, p_puntos_obtenidos);
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ResultadoAdicionar;
END PK_REGISTRAR_RESULTADO;
/
