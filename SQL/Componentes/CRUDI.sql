CREATE OR REPLACE PACKAGE BODY PK_REGISTRAR_TORNEO AS

    PROCEDURE torneoAdicionar(
        p_nombre IN VARCHAR2,
        p_fecha_inicio IN DATE,
        p_fecha_fin IN DATE,
        p_cupo IN NUMBER,
        p_plataforma_principal IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_organizador IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, juego, organizador)
        VALUES (p_nombre, p_fecha_inicio, p_fecha_fin, p_cupo, p_plataforma_principal, p_juego, p_organizador);
    END torneoAdicionar;

    PROCEDURE torneoModificar(
        p_nombre IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_cupo IN NUMBER,
        p_estado IN VARCHAR2
    ) IS
    BEGIN
        UPDATE Torneos
        SET nombre = p_nombre,
            cupo = p_cupo,
            estado = p_estado
        WHERE nombre = p_nombre AND juego = p_juego;
    END torneoModificar;


END PK_REGISTRAR_TORNEO;

/


CREATE OR REPLACE PACKAGE BODY PK_REGISTRAR_PRACTICA AS

    PROCEDURE practicaAdicionar(
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    ) IS
        v_evento_id NUMBER;
        v_torneo_id VARCHAR2(100);
    BEGIN
        SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = p_torneo AND juego = p_juego;
        SELECT numero_eventos+1 INTO v_evento_id FROM Torneos WHERE id = v_torneo_id;
        INSERT INTO Eventos (fecha, clima, hora_in_game, torneo, circuito)
        VALUES (p_fecha, p_clima, p_hora_in_game, v_torneo_id, p_circuito);
        INSERT INTO Practicas (id, torneo, duracion)
        VALUES (v_evento_id, v_torneo_id, p_duracion);

    END practicaAdicionar;
    
    PROCEDURE practicaModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    ) IS
        v_torneo_id VARCHAR2(100);
    BEGIN
        SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = p_torneo AND juego = p_juego;
        UPDATE Eventos
        SET fecha = p_fecha,
            clima = p_clima,
            hora_in_game = p_hora_in_game,
            circuito = p_circuito
        WHERE id = p_id AND torneo = v_torneo_id;
        UPDATE Practicas
        SET duracion = p_duracion
        WHERE id = p_id AND torneo = v_torneo_id;

    END practicaModificar;

END PK_REGISTRAR_PRACTICA;
/

CREATE OR REPLACE PACKAGE BODY PK_REGISTRAR_CLASIFICACION AS

    PROCEDURE clasificacionAdicionar(
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    ) IS
        v_evento_id NUMBER;
        v_torneo_id VARCHAR2(100);
    BEGIN
        SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = p_torneo AND juego = p_juego;
        SELECT numero_eventos+1 INTO v_evento_id FROM Torneos WHERE id = v_torneo_id;        
        INSERT INTO Eventos (fecha, clima, hora_in_game, torneo, circuito)
        VALUES (p_fecha, p_clima, p_hora_in_game, v_torneo_id, p_circuito);
        INSERT INTO Clasificaciones (id, torneo, duracion)
        VALUES (v_evento_id, v_torneo_id, p_duracion);

    END clasificacionAdicionar;

    PROCEDURE clasificacionModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    ) IS
        v_torneo_id VARCHAR2(100);
    BEGIN
        SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = p_torneo AND juego = p_juego;
        UPDATE Eventos
        SET fecha = p_fecha,
            clima = p_clima,
            hora_in_game = p_hora_in_game,
            circuito = p_circuito
        WHERE id = p_id AND torneo = v_torneo_id;
        UPDATE Clasificaciones
        SET duracion = p_duracion
        WHERE id = p_id AND torneo = v_torneo_id;
    END clasificacionModificar;

END PK_REGISTRAR_CLASIFICACION;

/
CREATE OR REPLACE PACKAGE BODY PK_REGISTRAR_CARRERA AS

    PROCEDURE carreraAdicionar(
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_numero_vueltas IN NUMBER
    ) IS
        v_torneo_id VARCHAR2(100);
        v_evento_id NUMBER;
    BEGIN
        SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = p_torneo AND juego = p_juego;
        SELECT numero_eventos+1 INTO v_evento_id FROM Torneos WHERE id = v_torneo_id;
        INSERT INTO Eventos (fecha, clima, hora_in_game, torneo, circuito)
        VALUES (p_fecha, p_clima, p_hora_in_game, v_torneo_id, p_circuito);
        INSERT INTO Carreras (id, torneo, numero_vueltas)
        VALUES (v_evento_id, v_torneo_id, p_numero_vueltas);

    END carreraAdicionar;

    PROCEDURE carreraModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_numero_vueltas IN NUMBER
    ) IS
        v_torneo_id VARCHAR2(100);
    BEGIN
        SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = p_torneo AND juego = p_juego;
        UPDATE Eventos
        SET fecha = p_fecha,
            clima = p_clima,
            hora_in_game = p_hora_in_game,
            circuito = p_circuito
        WHERE id = p_id AND torneo = v_torneo_id;
        UPDATE Carreras
        SET torneo = v_torneo_id,
            numero_vueltas = p_numero_vueltas
        WHERE id = p_id AND torneo = v_torneo_id;
    END carreraModificar;

END PK_REGISTRAR_CARRERA;
/
CREATE OR REPLACE PACKAGE BODY PK_MANTENER_ORGANIZADOR AS

    PROCEDURE organizadorAdicionar(
        p_nombre_usuario IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_correo IN VARCHAR2
    ) IS
    v_count NUMBER;
    BEGIN
    SELECT COUNT(*) INTO v_count FROM Usuarios WHERE nombre_usuario = p_nombre_usuario;
    IF v_count = 0 THEN
        INSERT INTO Usuarios (nombre_usuario, correo, pais)
        VALUES (p_nombre_usuario, p_correo, p_pais);
    END IF;
        INSERT INTO Organizadores (id)
        VALUES ((SELECT id FROM Usuarios WHERE nombre_usuario = p_nombre_usuario));
    END organizadorAdicionar;

    PROCEDURE organizadorModificar(
        p_nombre_usuario IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_correo IN VARCHAR2
    ) IS
    v_id_usuario VARCHAR2(100);
    BEGIN
        SELECT id INTO v_id_usuario FROM Usuarios WHERE nombre_usuario = p_nombre_usuario;
        UPDATE Usuarios
        SET pais = p_pais,
            correo = p_correo
        WHERE id = v_id_usuario;
    END organizadorModificar;

    PROCEDURE organizadorEliminar(
        p_nombre_usuario IN VARCHAR2
    ) IS
    v_id_usuario VARCHAR2(100);
    BEGIN
        SELECT id INTO v_id_usuario FROM Usuarios WHERE nombre_usuario = p_nombre_usuario;
        DELETE FROM Organizadores WHERE id = v_id_usuario;
    END organizadorEliminar;

END PK_MANTENER_ORGANIZADOR;
/
CREATE OR REPLACE PACKAGE BODY PK_MANTENER_VEHICULO AS

    PROCEDURE vehiculoAdicionar(
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2,
        p_a_o_vehiculo IN NUMBER,
        p_categoria IN VARCHAR2,
        p_peso IN NUMBER,
        p_hp IN NUMBER,
        p_juego IN VARCHAR2
    ) IS
    v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Vehiculos WHERE marca = p_marca_vehiculo AND referencia = p_referencia_vehiculo;
        IF v_count = 0 THEN
            INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp)
            VALUES (p_marca_vehiculo, p_referencia_vehiculo, p_a_o_vehiculo, p_categoria, p_peso, p_hp);
        END IF;
        INSERT INTO VehiculosdeJuegos (juego, marca_vehiculo, referencia_vehiculo) 
            VALUES (p_juego, p_marca_vehiculo, p_referencia_vehiculo);
    END vehiculoAdicionar;

    PROCEDURE vehiculoEliminar(
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2,
        p_juego IN VARCHAR2
    ) IS
    BEGIN
        DELETE FROM VehiculosdeJuegos WHERE juego = p_juego AND marca_vehiculo = p_marca_vehiculo AND referencia_vehiculo = p_referencia_vehiculo;
        DELETE FROM Vehiculos WHERE marca = p_marca_vehiculo AND referencia = p_referencia_vehiculo;
    END vehiculoEliminar;

END PK_MANTENER_VEHICULO;
/
CREATE OR REPLACE PACKAGE BODY PK_MANTENER_CIRCUITO AS

    PROCEDURE circuitoAdicionar(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_longitud IN NUMBER,
        p_juego IN VARCHAR2,
        p_clima IN VARCHAR2
    ) IS
    v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Circuitos WHERE nombre = p_nombre;
        IF v_count = 0 THEN
            INSERT INTO Circuitos (nombre, pais, longitud)
            VALUES (p_nombre, p_pais, p_longitud);
        END IF;
        INSERT INTO CircuitosDisponibles (juego, circuito, clima) 
        VALUES (p_juego, p_nombre, p_clima);
    END circuitoAdicionar;

    PROCEDURE circuitoEliminar(
        p_nombre IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_clima IN VARCHAR2
    ) IS
    BEGIN
        DELETE FROM CircuitosDisponibles WHERE juego = p_juego AND circuito = p_nombre AND clima = p_clima;
        DELETE FROM Circuitos WHERE nombre = p_nombre;
    END circuitoEliminar;

END PK_MANTENER_CIRCUITO;
/
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
/