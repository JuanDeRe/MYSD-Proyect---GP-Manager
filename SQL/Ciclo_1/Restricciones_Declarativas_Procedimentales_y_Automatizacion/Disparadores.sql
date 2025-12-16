--Disparadores
-- Se crea el id del usuario y se coloca su fecha de creacion
CREATE OR REPLACE TRIGGER trg_usuarios_creacion
BEFORE INSERT ON Usuarios
FOR EACH ROW
DECLARE
    -- numero ultimo usuario
    n_ultimo_usuario VARCHAR(200);
    -- parte string del usuario
    parte_usuario_id VARCHAR(200);
BEGIN
    IF :NEW.fecha_registro IS NULL THEN
    :NEW.fecha_registro := SYSDATE;
    END IF;
    -- extrae la parte del usuario del nombre de usuario
    parte_usuario_id := UPPER(SUBSTR(:NEW.nombre_usuario, 0, 3));
    -- obtiene la cantidad de usuarios 
    SELECT LPAD(TO_CHAR(NVL(COUNT(id),0)),7,0) INTO n_ultimo_usuario FROM Usuarios WHERE id LIKE (parte_usuario_id || '%');
    :NEW.id := parte_usuario_id || n_ultimo_usuario;
END;
/

-- Solo se puede cambiar el correo y pais de un usuario
CREATE OR REPLACE TRIGGER trg_usuarios_actualizar
BEFORE UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    IF (:OLD.id != :NEW.id) OR
    (:OLD.nombre_usuario != :NEW.nombre_usuario) OR
    (:OLD.fecha_registro != :NEW.fecha_registro) THEN
        RAISE_APPLICATION_ERROR(-20015, 'Solo se puede cambiar el correo y pais de un usuario');
    END IF;
END;
/

-- Cada organizador comienza con total torneos creados = 0  
CREATE OR REPLACE TRIGGER trg_organizadores_creacion
BEFORE INSERT ON Organizadores
FOR EACH ROW
BEGIN
    :NEW.total_torneos_creados := 0;
END;
/

-- Secuencia para id torneos
CREATE SEQUENCE seq_torneo_id START WITH 1 INCREMENT BY 1;


--Se coloca su estado correspondiente, numero de eventos en 0 y se verifica que las fechas sean validas
CREATE OR REPLACE TRIGGER trg_torneos_creacion
BEFORE INSERT ON Torneos
FOR EACH ROW
BEGIN
    IF :NEW.Fecha_fin < :NEW.Fecha_inicio THEN
        RAISE_APPLICATION_ERROR(-20016, 'Fecha de torneo invalida');
    END IF;
    :NEW.estado := 'Programado';
    :NEW.id := :NEW.organizador || LPAD(seq_torneo_id.NEXTVAL, 10, '0');
    :NEW.numero_eventos := 0;
END;
/


-- Cuando se actualizan torneos creados del organizador
CREATE OR REPLACE TRIGGER trg_torneos_actualizar_organizador
AFTER INSERT ON Torneos
FOR EACH ROW
BEGIN
    UPDATE Organizadores SET total_torneos_creados = total_torneos_creados+1 WHERE id = :NEW.organizador;
END;
/

-- Solo se puede pasar de estado Programado a En curso, de En curso a Finalizado y de Programado a Cancelado.
-- Solo se puede cambiar el cupo, el nombre y el estado del torneo
CREATE OR REPLACE TRIGGER trg_torneos_actualizar_estado
BEFORE UPDATE ON Torneos
FOR EACH ROW
DECLARE
    v_eventos_no_finalizados NUMBER;
BEGIN
    -- columnas que no se pueden modificar
    IF 
    :NEW.id != :OLD.id OR
    :NEW.fecha_inicio != :OLD.fecha_inicio OR
    :NEW.fecha_fin != :OLD.fecha_fin OR
    :NEW.plataforma_principal != :OLD.plataforma_principal OR
    :NEW.juego != :OLD.juego OR
    :NEW.organizador != :OLD.organizador
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'Solo se puede actualizar el cupo, nombre y estado del torneo');
    END IF;
    -- verificacion consistencia de cambio de estados
    IF 
    (:NEW.estado = 'Finalizado' AND (:OLD.estado != 'En curso')) OR
    (:NEW.estado = 'En curso' AND (:OLD.estado NOT IN ('Programado','En curso'))) OR
    (:NEW.estado = 'Programado' AND (:OLD.estado != 'Programado')) OR
    (:NEW.estado = 'Cancelado' AND (:OLD.estado != 'Programado')) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Solo se puede pasar de estado Programado a En curso, de En curso a Finalizado y de Programado a Cancelado');
    END IF;
    IF (:NEW.estado = 'Finalizado') THEN
    -- cuenta los eventos finalizados del torneo
        SELECT COUNT(id) INTO v_eventos_no_finalizados FROM Eventos
        WHERE torneo = :NEW.id AND estado != 'Finalizado';
        IF (v_eventos_no_finalizados > 0) THEN
            RAISE_APPLICATION_ERROR (-20020, 'Todos los eventos deben estar finalizados para que el torneo este finalizado');
        END IF;
    END IF;
END;
/
-- Si se cancela el torneo, se deben cancelar los eventos asociados
CREATE OR REPLACE TRIGGER trg_torneos_actualizar_estado_cancelado
AFTER UPDATE ON Torneos
FOR EACH ROW
BEGIN
    IF :NEW.estado = 'Cancelado' THEN
        UPDATE Eventos SET estado = 'Cancelado' WHERE torneo = :OLD.id;
    END IF;
END;
/

-- No se pueden eliminar Torneos
CREATE OR REPLACE TRIGGER trg_Torneos_eliminar
BEFORE DELETE ON Torneos
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20015, 'No se pueden eliminar torneos');
END;
/

-- Se crea la id del Evento, se verifica que la fecha este en el rango del torneo, que el circuito y el clima
-- exista en el juego del torneo y se define el estado.
-- Solo se pueden agregar eventos a un torneo que este Programado
CREATE OR REPLACE TRIGGER trg_eventos_creacion
BEFORE INSERT ON Eventos
FOR EACH ROW
DECLARE
    v_estado_torneo   Torneos.estado%TYPE;
    v_fecha_inicio    Torneos.fecha_inicio%TYPE;
    v_fecha_fin       Torneos.fecha_fin%TYPE;
    v_juego_torneo    Torneos.juego%TYPE;
    v_circuito_ok     NUMBER;
    v_clima_ok        NUMBER;
    v_numero_eventos   NUMBER;
BEGIN
    SELECT estado, fecha_inicio, fecha_fin, juego, numero_eventos
    INTO v_estado_torneo, v_fecha_inicio, v_fecha_fin, v_juego_torneo, v_numero_eventos
    FROM Torneos
    WHERE id = :NEW.torneo;
    IF v_estado_torneo != 'Programado' THEN
        RAISE_APPLICATION_ERROR(-20006, 'No se pueden agregar eventos a un torneo que no esté en estado Programado');
    END IF;
    IF :NEW.fecha < v_fecha_inicio OR :NEW.fecha > v_fecha_fin THEN
        RAISE_APPLICATION_ERROR(-20004, 'La fecha del evento no está dentro del calendario del torneo');
    END IF;
    SELECT COUNT(*) INTO v_circuito_ok
    FROM CircuitosDisponibles
    WHERE circuito = :NEW.circuito
      AND juego = v_juego_torneo;
    IF v_circuito_ok = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Circuito no disponible en el juego del torneo');
    END IF;
    SELECT COUNT(*) INTO v_clima_ok
    FROM CircuitosDisponibles
    WHERE circuito = :NEW.circuito
      AND juego = v_juego_torneo
      AND clima = :NEW.clima;
    IF v_clima_ok = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Condiciones climáticas del circuito no disponibles en el juego del torneo');
    END IF;
    :NEW.id := v_numero_eventos + 1;
    :NEW.estado := 'Programado';
END;
/

-- Se actualiza el numero de eventos del torneo
CREATE OR REPLACE TRIGGER trg_eventos_actualizar_numero_torneo
AFTER INSERT ON Eventos
FOR EACH ROW
BEGIN
    UPDATE Torneos SET numero_eventos = numero_eventos+1
    WHERE id = :NEW.torneo;
END;
/

--De un evento solo se puede actualizar su fecha si el torneo esta en estado programado y si esta dentro del calendario del torneo. 
--Tambien el resto de columnas menos el id, el torneo.
--Solo se puede pasar de estado Programado a En curso, de En curso a Finalizado y de Programado a Cancelado.
CREATE OR REPLACE TRIGGER trg_eventos_actualizar
BEFORE UPDATE ON Eventos
FOR EACH ROW
DECLARE
    v_torneo_info   Torneos%ROWTYPE;
    v_valida        NUMBER;
    v_torneo_estado Torneos.estado%TYPE;
BEGIN
    -- Si se está actualizando a Cancelado y proviene de un trigger de cancelación de torneo, omitir validaciones
    IF :NEW.estado = 'Cancelado' AND :OLD.estado = 'Programado' THEN
        RETURN;
    END IF;

    IF UPDATING('id') OR UPDATING('torneo') THEN
        RAISE_APPLICATION_ERROR(-20007,'No se pueden modificar el id ni el torneo de un evento');
    END IF;

    --Validar transiciones de estado
    IF :OLD.estado != :NEW.estado THEN
        CASE :OLD.estado
            WHEN 'Programado' THEN
                IF :NEW.estado NOT IN ('En curso', 'Cancelado') THEN
                    RAISE_APPLICATION_ERROR(-20008, 
                        'De Programado solo se permite cambiar a En curso o Cancelado');
                END IF;
            WHEN 'En curso' THEN
                IF :NEW.estado != 'Finalizado' THEN
                    RAISE_APPLICATION_ERROR(-20008, 
                        'De En curso solo se permite cambiar a Finalizado');
                END IF;
            WHEN 'Finalizado' THEN
                IF :NEW.estado != 'Finalizado' THEN
                    RAISE_APPLICATION_ERROR(-20008, 
                        'No se puede modificar el estado de un evento Finalizado');
                END IF;
            ELSE
                RAISE_APPLICATION_ERROR(-20008, 'Estado no válido para transición');
        END CASE;
    END IF;

    -- Si no está en Programado, solo permitir cambio de estado
    IF :OLD.estado != 'Programado' AND (
        :NEW.fecha != :OLD.fecha OR
        :NEW.circuito != :OLD.circuito OR
        :NEW.clima != :OLD.clima OR
        :NEW.hora_in_game != :OLD.hora_in_game
    ) THEN
        RAISE_APPLICATION_ERROR(-20010, 
            'Solo eventos en estado Programado pueden modificar sus datos');
    END IF;

    --Validaciones solo si está en estado Programado
    IF :OLD.estado = 'Programado' AND :NEW.estado != 'Cancelado' THEN
        -- Obtener datos del torneo
        SELECT fecha_inicio, fecha_fin, juego
        INTO v_torneo_info.fecha_inicio, v_torneo_info.fecha_fin, v_torneo_info.juego
        FROM Torneos
        WHERE id = :NEW.torneo;

        -- Validar fecha dentro del calendario
        IF :NEW.fecha NOT BETWEEN v_torneo_info.fecha_inicio 
                             AND v_torneo_info.fecha_fin THEN
            RAISE_APPLICATION_ERROR(-20009,
                'La fecha del evento debe estar dentro del calendario del torneo');
        END IF;

        -- Validar circuito y clima en una sola consulta
        SELECT COUNT(*)
        INTO v_valida
        FROM CircuitosDisponibles cd
        WHERE cd.circuito = :NEW.circuito
          AND cd.juego = v_torneo_info.juego
          AND cd.clima = :NEW.clima;

        IF v_valida = 0 THEN
            SELECT COUNT(*)
            INTO v_valida
            FROM CircuitosDisponibles cd
            WHERE cd.circuito = :NEW.circuito
              AND cd.juego = v_torneo_info.juego;

            IF v_valida = 0 THEN
                RAISE_APPLICATION_ERROR(-20011,
                    'Circuito no disponible en el juego del torneo');
            ELSE
                RAISE_APPLICATION_ERROR(-20017,
                    'Condiciones climáticas no disponibles para este circuito');
            END IF;
        END IF;
    END IF;
END;
/
--Si por lo menos un evento esta en curso, el torneo pasa a estar en curso.
CREATE OR REPLACE TRIGGER trg_eventos_actualizar_torneo
AFTER UPDATE ON Eventos
FOR EACH ROW
BEGIN
    IF :NEW.estado = 'En curso' THEN
        UPDATE Torneos 
        SET estado = 'En curso'
        WHERE id = :NEW.torneo;
    END IF;    
END;
/

--No se pueden eliminar Eventos
CREATE OR REPLACE TRIGGER trg_Eventos_eliminar
BEFORE DELETE ON Eventos
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20016, 'No se pueden eliminar eventos');
END;
/

-- Un evento solo puede ser o carrera, o clasificacion o practica
CREATE OR REPLACE TRIGGER trg_carrera_exclusiva
BEFORE INSERT ON Carreras
FOR EACH ROW
DECLARE
    clasificacion Clasificaciones.id%TYPE;
    practica Practicas.id%TYPE;
BEGIN
    SELECT COUNT(id) INTO clasificacion FROM Clasificaciones
    WHERE torneo = :NEW.torneo AND id = :NEW.id;
    SELECT COUNT(id) INTO practica FROM Practicas
    WHERE torneo = :NEW.torneo AND id = :NEW.id;
    IF (clasificacion > 0 OR practica > 0) THEN
        RAISE_APPLICATION_ERROR(-20019, 'Un evento solo puede ser o carrera, o clasificacion o practica');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_clasificacion_exclusiva
BEFORE INSERT ON Clasificaciones
FOR EACH ROW
DECLARE
    carrera Carreras.id%TYPE;
    practica Practicas.id%TYPE;
BEGIN
    SELECT COUNT(id) INTO carrera FROM Carreras
    WHERE torneo = :NEW.torneo AND id = :NEW.id;
    SELECT COUNT(id) INTO practica FROM Practicas
    WHERE torneo = :NEW.torneo AND id = :NEW.id;
    IF (carrera > 0 OR practica > 0) THEN
        RAISE_APPLICATION_ERROR(-20019, 'Un evento solo puede ser o carrera, o clasificacion o practica');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_practica_exclusiva
BEFORE INSERT ON Practicas
FOR EACH ROW
DECLARE
    clasificacion Clasificaciones.id%TYPE;
    carrera Carreras.id%TYPE;
BEGIN
    SELECT COUNT(id) INTO clasificacion FROM Clasificaciones
    WHERE torneo = :NEW.torneo AND id = :NEW.id;
    SELECT COUNT(id) INTO carrera FROM Carreras
    WHERE torneo = :NEW.torneo AND id = :NEW.id;
    IF (clasificacion > 0 OR carrera > 0) THEN
        RAISE_APPLICATION_ERROR(-20019, 'Un evento solo puede ser o carrera, o clasificacion o practica');
    END IF;
END;
/

-- Solo se puede actualizar el numero de vueltas si el evento esta en estado Programado
CREATE OR REPLACE TRIGGER trg_Carrera_estado_programado
BEFORE UPDATE ON Carreras
FOR EACH ROW
DECLARE
    estado_evento Eventos.estado%TYPE;
BEGIN
    SELECT estado INTO estado_evento FROM Eventos
    WHERE id = :NEW.id AND torneo = :NEW.torneo;
    IF 'Programado' != estado_evento  AND :NEW.numero_vueltas != :OLD.numero_vueltas THEN
        RAISE_APPLICATION_ERROR(-20012, 'Solo se pueden cambiar el numero de vueltas si el evento esta en estado Programado');
    END IF;
END;
/
-- Solo se puede actualizar la duracion si el evento esta en estado Programado
CREATE OR REPLACE TRIGGER trg_clasificaciones_estado_programado
BEFORE UPDATE ON Clasificaciones
FOR EACH ROW
DECLARE
    estado_evento Eventos.estado%TYPE;
BEGIN
    SELECT estado INTO estado_evento FROM Eventos
    WHERE id = :NEW.id AND torneo = :NEW.torneo;
    IF ('Programado') != estado_evento AND :NEW.duracion != :OLD.duracion THEN
        RAISE_APPLICATION_ERROR(-20013, 'Solo se pueden cambiar la duracion si el evento esta en estado Programado');
    END IF;
END;
/
-- Solo se puede actualizar la duracion si el evento esta en estado Programado
CREATE OR REPLACE TRIGGER trg_practicas_estado_programado
BEFORE UPDATE ON Practicas
FOR EACH ROW
DECLARE
    estado_evento Eventos.estado%TYPE;
BEGIN
    SELECT estado INTO estado_evento FROM Eventos
    WHERE id = :NEW.id AND torneo = :NEW.torneo;
    IF ('Programado') != estado_evento AND :NEW.duracion != :OLD.duracion THEN
        RAISE_APPLICATION_ERROR(-20014, 'Solo se pueden cambiar la duracion si el evento esta en estado Programado');
    END IF;
END;
/
