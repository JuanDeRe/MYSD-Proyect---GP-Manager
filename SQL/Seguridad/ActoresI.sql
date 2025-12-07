CREATE OR REPLACE PACKAGE BODY pk_organizador AS

    PROCEDURE organizadorAdicionar(nombre_usuario VARCHAR, pais VARCHAR, correo VARCHAR) IS
        BEGIN
            PK_MANTENER_ORGANIZADOR.organizadorAdicionar(nombre_usuario, pais, correo);
        END organizadorAdicionar;
    
    PROCEDURE organizadorModificar(nombre_usuario VARCHAR, correo VARCHAR, pais VARCHAR) IS
        BEGIN
            PK_MANTENER_ORGANIZADOR.organizadorModificar(nombre_usuario, correo, pais);
        END organizadorModificar;

    PROCEDURE organizadorEliminar(nombre_usuario VARCHAR) IS
        BEGIN
            PK_MANTENER_ORGANIZADOR.organizadorEliminar(nombre_usuario);
        END organizadorEliminar;

    PROCEDURE torneoAdicionar(nombre VARCHAR, fecha_inicio DATE, fecha_fin DATE, cupo NUMBER, plataforma_principal VARCHAR, juego VARCHAR, organizador VARCHAR) IS
        BEGIN
            PK_REGISTRAR_TORNEO.torneoAdicionar(nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, juego, organizador);
        END torneoAdicionar;

    PROCEDURE torneoModificar(nombre VARCHAR, juego VARCHAR, cupo NUMBER, estado VARCHAR) IS
        BEGIN
            PK_REGISTRAR_TORNEO.torneoModificar(nombre, juego, cupo, estado);
        END torneoModificar;

    PROCEDURE eventoAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR) IS
        BEGIN
            PK_REGISTRAR_EVENTO.eventoAdicionar(torneo, juego, fecha, clima, hora_in_game, circuito);
        END eventoAdicionar;

    PROCEDURE eventoModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR) IS
        BEGIN
            PK_REGISTRAR_EVENTO.eventoModificar(id, torneo, juego, fecha, clima, hora_in_game, circuito);
        END eventoModificar;

    PROCEDURE carreraAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, numero_vueltas NUMBER) IS
        BEGIN
            PK_REGISTRAR_CARRERA.carreraAdicionar(torneo, juego, fecha, clima, hora_in_game, circuito, numero_vueltas);
        END carreraAdicionar;

    PROCEDURE carreraModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, numero_vueltas NUMBER) IS
        BEGIN
            PK_REGISTRAR_CARRERA.carreraModificar(id, torneo, juego, fecha, clima, hora_in_game, circuito, numero_vueltas);
        END carreraModificar;

    PROCEDURE clasificacionAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR) IS
        BEGIN
            PK_REGISTRAR_CLASIFICACION.clasificacionAdicionar(torneo, juego, fecha, clima, hora_in_game, circuito, duracion);
        END clasificacionAdicionar;

    PROCEDURE clasificacionModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR) IS
        BEGIN
            PK_REGISTRAR_CLASIFICACION.clasificacionModificar(id, torneo, juego, fecha, clima, hora_in_game, circuito, duracion);
        END clasificacionModificar;

    PROCEDURE practicaAdicionar(torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR) IS
        BEGIN
            PK_REGISTRAR_PRACTICA.practicaAdicionar(torneo, juego, fecha, clima, hora_in_game, circuito, duracion);
        END practicaAdicionar;

    PROCEDURE practicaModificar(id NUMBER, torneo VARCHAR, juego VARCHAR, fecha DATE, clima VARCHAR, hora_in_game VARCHAR, circuito VARCHAR, duracion VARCHAR) IS
        BEGIN
            PK_REGISTRAR_PRACTICA.practicaModificar(id, torneo, juego, fecha, clima, hora_in_game, circuito, duracion);
        END practicaModificar;

    FUNCTION consultarVehiculosTorneo(id VARCHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM v_vehiculos_torneo WHERE torneo_id = id;       
        RETURN v_cursor;
    END consultarVehiculosTorneo;

    FUNCTION consultarCircuitosTorneo(id VARCHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM v_circuitos_torneo WHERE torneo_id = id;        
        RETURN v_cursor;
    END consultarCircuitosTorneo;

    FUNCTION consultarDetallesTorneo(id VARCHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM v_resumen_torneo_organizador WHERE torneo_id = id;
        RETURN v_cursor;
    END consultarDetallesTorneo;
END pk_organizador;
/

CREATE OR REPLACE PACKAGE BODY pk_desarrollador AS

    PROCEDURE vehiculoAdicionar(marca VARCHAR, referencia VARCHAR, a_o NUMBER, categoria VARCHAR, peso NUMBER, hp NUMBER, juego VARCHAR) IS
        BEGIN
            PK_MANTENER_VEHICULO.vehiculoAdicionar(marca, referencia, a_o, categoria, peso, hp, juego);
        END vehiculoAdicionar;

    PROCEDURE vehiculoEliminar(marca VARCHAR, referencia VARCHAR, juego VARCHAR) IS
        BEGIN
            PK_MANTENER_VEHICULO.vehiculoEliminar(marca, referencia, juego);
        END vehiculoEliminar;

    PROCEDURE circuitoAdicionar(nombre VARCHAR, pais VARCHAR, longitud NUMBER, juego VARCHAR, clima VARCHAR) IS
        BEGIN
            PK_MANTENER_CIRCUITO.circuitoAdicionar(nombre, pais, longitud, juego, clima);
        END circuitoAdicionar;

    PROCEDURE circuitoEliminar(nombre VARCHAR, juego VARCHAR, clima VARCHAR) IS
        BEGIN
            PK_MANTENER_CIRCUITO.circuitoEliminar(nombre, juego, clima);
        END circuitoEliminar;

    PROCEDURE juegoAdicionar(nombre VARCHAR) IS
        BEGIN
            PK_MANTENER_JUEGO.juegoAdicionar(nombre);
        END juegoAdicionar;

    PROCEDURE juegoEliminar(nombre VARCHAR) IS
        BEGIN
            PK_MANTENER_JUEGO.juegoEliminar(nombre);
        END juegoEliminar;

    PROCEDURE organizadorEliminar(nombre_usuario VARCHAR) IS
        BEGIN
            PK_MANTENER_ORGANIZADOR.organizadorEliminar(nombre_usuario);
        END organizadorEliminar;

END pk_desarrollador;
/

CREATE OR REPLACE PACKAGE BODY pk_jugador AS
    FUNCTION consultarEventosTorneo(id VARCHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM v_eventos_torneos_detalle WHERE torneo_id = id;
        RETURN v_cursor;
    END consultarEventosTorneo;

    FUNCTION consultarVehiculosJuego(nombre_juego VARCHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM v_vehiculos_por_juego WHERE juego = nombre_juego;
        RETURN v_cursor;
    END consultarVehiculosJuego;

    FUNCTION consultarCircuitosJuego(nombre_juego VARCHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM v_circuitos_por_juego WHERE juego = nombre_juego;
        RETURN v_cursor;
    END consultarCircuitosJuego;

    FUNCTION consultarDetallesTorneo(id VARCHAR) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM v_resumen_torneo_organizador WHERE torneo_id = id;
        RETURN v_cursor;
    END consultarDetallesTorneo;
END pk_jugador;
/