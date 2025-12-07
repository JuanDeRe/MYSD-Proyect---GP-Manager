CREATE OR REPLACE PACKAGE BODY PK_MANTENER_TORNEO AS

    PROCEDURE torneoAdicionar(
        p_nombre IN VARCHAR2,
        p_fecha_inicio IN DATE,
        p_fecha_fin IN DATE,
        p_cupo IN NUMBER,
        p_plataforma_principal IN VARCHAR2,
        p_juego IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, juego)
        VALUES (p_nombre, p_fecha_inicio, p_fecha_fin, p_cupo, p_plataforma_principal, p_juego);
    END torneoAdicionar;

    PROCEDURE torneoModificar(
        p_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_cupo IN NUMBER,
        p_estado IN VARCHAR2
    ) IS
    BEGIN
        UPDATE Torneos
        SET nombre = p_nombre,
            cupo = p_cupo,
            estado = p_estado
        WHERE id = p_id;
    END torneoModificar;

    PROCEDURE torneoEliminar(
        p_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Torneos WHERE id = p_id;
    END torneoEliminar;

END PK_MANTENER_TORNEO;




CREATE OR REPLACE PACKAGE BODY PK_MANTENER_PRACTICA AS

    PROCEDURE practicaAdicionar(
        p_torneo IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN NUMBER
    ) IS
    DECLARE
        v_evento_id NUMBER;
    BEGIN
        SELECT SEQ_EVENTOS.NEXTVAL INTO v_evento_id FROM DUAL;
        INSERT INTO Eventos (id, fecha, clima, hora_in_game, torneo, circuito)
        VALUES (v_evento_id, p_fecha, p_clima, p_hora_in_game, p_torneo, p_circuito);
        INSERT INTO Practicas (id, torneo, duracion)
        VALUES (v_evento_id, p_torneo, p_duracion);

    END practicaAdicionar;

    PROCEDURE practicaModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN NUMBER
    ) IS
    BEGIN
        UPDATE Eventos
        SET fecha = p_fecha,
            clima = p_clima,
            hora_in_game = p_hora_in_game,
            torneo = p_torneo,
            circuito = p_circuito
        WHERE id = p_id;
        UPDATE Practicas
        SET torneo = p_torneo,
            duracion = p_duracion
        WHERE id = p_id;
    END practicaModificar;
    PROCEDURE practicaEliminar(
        p_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Practicas WHERE id = p_id;
        DELETE FROM Eventos WHERE id = p_id;
    END practicaEliminar;
END PK_MANTENER_PRACTICA;


CREATE OR REPLACE PACKAGE BODY PK_MANTENER_CLASIFICACION AS

    PROCEDURE clasificacionAdicionar(
        p_torneo IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    ) IS
    DECLARE
        v_evento_id NUMBER;
    BEGIN
        SELECT SEQ_EVENTOS.NEXTVAL INTO v_evento_id FROM DUAL;
        INSERT INTO Eventos (id, fecha, clima, hora_in_game, torneo, circuito)
        VALUES (v_evento_id, p_fecha, p_clima, p_hora_in_game, p_torneo, p_circuito);
        INSERT INTO Clasificaciones (id, torneo, duracion)
        VALUES (v_evento_id, p_torneo, p_duracion);

    END clasificacionAdicionar;

    PROCEDURE clasificacionModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    ) IS
    BEGIN
        UPDATE Eventos
        SET fecha = p_fecha,
            clima = p_clima,
            hora_in_game = p_hora_in_game,
            torneo = p_torneo,
            circuito = p_circuito
        WHERE id = p_id;
        UPDATE Clasificaciones
        SET torneo = p_torneo,
            duracion = p_duracion
        WHERE id = p_id;
    END clasificacionModificar;
    PROCEDURE clasificacionEliminar(
        p_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Clasificaciones WHERE id = p_id;
        DELETE FROM Eventos WHERE id = p_id;
    END clasificacionEliminar;
END PK_MANTENER_CLASIFICACION;


CREATE OR REPLACE PACKAGE BODY PK_MANTENER_CARRERA AS

    PROCEDURE carreraAdicionar(
        p_torneo IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_numero_vueltas IN NUMBER
    ) IS
    DECLARE
        v_evento_id NUMBER;
    BEGIN
        SELECT SEQ_EVENTOS.NEXTVAL INTO v_evento_id FROM DUAL;
        INSERT INTO Eventos (id, fecha, clima, hora_in_game, torneo, circuito)
        VALUES (v_evento_id, p_fecha, p_clima, p_hora_in_game, p_torneo, p_circuito);
        INSERT INTO Carreras (id, torneo, numero_vueltas)
        VALUES (v_evento_id, p_torneo, p_numero_vueltas);

    END carreraAdicionar;

    PROCEDURE carreraModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_numero_vueltas IN NUMBER
    ) IS
    BEGIN
        UPDATE Eventos
        SET fecha = p_fecha,
            clima = p_clima,
            hora_in_game = p_hora_in_game,
            torneo = p_torneo,
            circuito = p_circuito
        WHERE id = p_id;
        UPDATE Carreras
        SET torneo = p_torneo,
            numero_vueltas = p_numero_vueltas
        WHERE id = p_id;
    END carreraModificar;

    PROCEDURE carreraEliminar(
        p_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Carreras WHERE id = p_id;
        DELETE FROM Eventos WHERE id = p_id;
    END carreraEliminar;
END PK_MANTENER_CARRERA;

CREATE OR REPLACE PACKAGE BODY PK_MANTENER_ORGANIZADOR AS

    PROCEDURE organizadorAdicionar(
        p_nombre_usuario IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_correo IN VARCHAR2
    ) IS
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE nombre_usuario = p_nombre_usuario) THEN
            INSERT INTO Usuarios (nombre_usuario, correo) VALUES (p_nombre_usuario, p_correo);
        END IF;
        INSERT INTO Organizadores (id)
        VALUES ((SELECT id FROM Usuarios WHERE nombre_usuario = p_nombre_usuario));
    END organizadorAdicionar;

    PROCEDURE organizadorModificar(
        p_nombre_usuario IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_correo IN VARCHAR2
    ) IS
    BEGIN
        UPDATE Organizadores
        SET pais = p_pais,
            correo = p_correo
        WHERE nombre_usuario = p_nombre_usuario;
    END organizadorModificar;

    PROCEDURE organizadorEliminar(
        p_nombre_usuario IN VARCHAR2
    ) IS
    BEGIN
        DELETE FROM Organizadores WHERE nombre_usuario = p_nombre_usuario;
    END organizadorEliminar;

END PK_MANTENER_ORGANIZADOR;

CREATE OR REPLACE PACKAGE BODY PK_MANTENER_VEHICULO AS

    PROCEDURE vehiculoAdicionar(
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2,
        p_a_o_vehiculo IN NUMBER,
        p_categoria IN VARCHAR2,
        p_peso IN NUMBER,
        p_hp IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp)
        VALUES (p_marca_vehiculo, p_referencia_vehiculo, p_a_o_vehiculo, p_categoria, p_peso, p_hp);
    END vehiculoAdicionar;

    PROCEDURE vehiculoEliminar(
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2
    ) IS
    BEGIN
        DELETE FROM Vehiculos WHERE marca = p_marca_vehiculo AND referencia = p_referencia_vehiculo;
    END vehiculoEliminar;

END PK_MANTENER_VEHICULO;

CREATE OR REPLACE PACKAGE BODY PK_MANTENER_CIRCUITO AS

    PROCEDURE circuitoAdicionar(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_longitud IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Circuitos (nombre, pais, longitud)
        VALUES (p_nombre, p_pais, p_longitud);
    END circuitoAdicionar;

    PROCEDURE circuitoEliminar(
        p_nombre IN VARCHAR2
    ) IS
    BEGIN
        DELETE FROM Circuitos WHERE nombre = p_nombre;
    END circuitoEliminar;

END PK_MANTENER_CIRCUITO;

CREATE OR REPLACE PACKAGE BODY PK_MANTENER_JUEGO AS

    PROCEDURE juegoAdicionar(
        p_nombre IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Juegos (nombre)
        VALUES (p_nombre);
    END juegoAdicionar;

    PROCEDURE juegoEliminar(
        p_nombre IN VARCHAR2
    ) IS
    BEGIN
        DELETE FROM Juegos WHERE nombre = p_nombre;
    END juegoEliminar;

END PK_MANTENER_JUEGO;