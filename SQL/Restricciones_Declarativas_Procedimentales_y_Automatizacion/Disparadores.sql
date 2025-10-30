--Disparadores
-- Se crea el id del usuario y se coloca su fecha de creacion
CREATE OR REPLACE TRIGGER trg_usuarios_creacion
BEFORE INSERT ON Usuarios
FOR EACH ROW
DECLARE
    n_ultimo_usuario VARCHAR;
    parte_usuario_id VARCHAR;
BEGIN
    :NEW.fecha_registro := SYSDATE;
    parte_usuario_id := UPPER(SUBSTR(:NEW.nombre_usuario, 0, 3));
    SELECT LPAD(TO_CHAR(NVL(COUNT(id),0)),7,0) INTO n_ultimo_usuario FROM Usuarios WHERE id LIKE (parte_usuario_id || '%');
    :NEW.id := parte_usuario_id || n_ultimo_usuario;
END;
/

-- No se pueden cambiar ni eliminar el id de usuario, 


-- Se crea la id del torneo, se coloca su estado correspondiente y se verifica que las fechas sean validas
CREATE OR REPLACE TRIGGER trg_torenos_creacion
BEFORE INSERT ON Torneos
FOR EACH ROW
DECLARE
    parte_usuario_id VARCHAR := :NEW.organizador;
    parte_n_torneos NUMBER;
BEGIN
    IF :NEW.Fecha_fin < SYSDATE OR :NEW.Fecha_inicio < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Fecha de torneo invalida');
    END IF;
    IF :NEW.Fecha_inicio = TO_DATE(SYSDATE, 'YYYY-MM-DD') THEN
        :NEW.estado := 'En curso';
    END IF;
    IF :NEW:fecha_inicio > TO_DATE(SYSDATE, 'YYYY-MM-DD') THEN
        :NEW.estado := 'Programado';
    END IF;
    SELECT LPAD(TO_CHAR(NVL(COUNT(id)),0),10,0) INTO parte_parte_n_torneos FROM parte_n_torneos
    WHERE organizador = :NEW.organizador;
    :NEW.id := parte_usuario_id || parte_n_torneos;
END;
/

-- Cuando se crea un torneo se actualizan los torneos creados del organizador
CREATE OR REPLACE TRIGGER trg_torneos_actualizar_organizador
AFTER INSERT ON Torneos
FOR EACH ROW
DECLARE
    nuevo_contador NUMBER;
BEGIN
    SELECT NVL(COUNT(id),0) INTO nuevo_contador FROM Torneos
    GROUP BY id
    WHERE organizador = :NEW.organizador;
    UPDATE Organizadores SET total_torneos_creados = nuevo_contador WHERE id = :NEW.organizador;
END;
/

-- Solo se puede pasar de estado Programado a En curso, de En curso a Finalizado y de Programado a Cancelado.
-- Solo se puede cambiar el cupo, el nombre y el estado del torneo
CREATE OR REPLACE TRIGGER trg_torneos_actualizar_estado
BEFORE UPDATE ON Torneos
FOR EACH ROW
BEGIN
    IF 
    :NEW.id != :OLD.id OR
    :NEW.fecha_inicio != :OLD.fecha_inicio OR
    :NEW:fecha_fin != :OLD.fecha_fin OR
    :NEW.plataforma_principal != :OLD.plataforma_principal OR
    :NEW.juego != :OLD.juego OR
    :NEW.organizador != :OLD.organizador
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'Solo se puede actualizar el cupo, nombre y estado del torneo');
    END IF;
    IF 
    (:NEW.estado = 'Finalizado' AND (:OLD.estado != 'En curso')) OR
    (:NEW.estado = 'En curso' AND (:OLD.estado != 'Programado')) OR
    (:NEW.estado = 'Cancelado' AND (:OLD.estado != 'Programado')) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Solo se puede pasar de estado Programado a En curso, de En curso a Finalizado y de Programado a Cancelado');
    END IF;
END;
/
-- Si se cancela el torneo, se deben cancelar los eventos asociados
CREATE OR REPLACE TRIGGER trg_torneos_actualizar_estado_cancelado
BEFORE UPDATE ON Torneos
FOR EACH ROW
BEGIN
    IF :NEW.estado = 'Cancelado' THEN
        UPDATE Eventos SET estado = 'Cancelado' WHERE torneo = :OLD.id;
    END IF;
END;
/

-- Se crea la id del Evento, se verifica que la fecha este en el rango del torneo, que el circuito y el clima
-- exista en el juego del torneo y se define el estado.
-- Solo se pueden agregar eventos a un torneo que este Programado
CREATE OR REPLACE TRIGGER trg_eventos_creacion
BEFORE INSERT ON Eventos
FOR EACH ROW
DECLARE
    numero_evento VARCHAR;
BEGIN
    IF (SELECT estado FROM Torneos WHERE id = :NEW.torneo) != 'Programado' THEN
        RAISE_APPLICATION_ERROR(-20006, 'No se pueden agregar eventos a un torneo que no este en estado Programado');
    END IF;
    IF :NEW.fecha > (SELECT fecha_fin FROM Torneos WHERE id = :NEW.torneo) OR 
    :NEW.fecha < (SELECT fecha_inicio FROM Torneos WHERE id = :NEW.torneo) THEN
    RAISE_APPLICATION_ERROR(-20004, 'La fecha del evento no esta dentro del calendario del torneo');
    END IF;
    IF NOT (:NEW.circuito IN (SELECT circuito FROM CircuitosDisponibles WHERE juego = (SELECT juego FROM Torneos WHERE id = torneo)))
    OR NOT (:NEW.clima IN (SELECT clima FROM CircuitosDisponibles WHERE circuito = :NEW.circuito AND juego = (SELECT juego FROM Torneos WHERE id = torneo))) THEN
    RAISE_APPLICATION_ERROR(-20005, 'Circuito o condiciones climaticas del circuito no disponibles en el juego del torneo');
    END IF;
    SELECT LPAD(TO_CHAR(NVL(COUNT(torneo),0)),4,0) INTO numero_evento FROM Eventos 
    WHERE torneo = :NEW.torneo;
    :NEW.id := numero_evento;
    :NEW.estado := 'Programado';
END;
/


--De un evento solo se puede actualizar su fecha si el torneo esta en estado programado y si esta dentro del calendario del torneo. 
--Tambien el resto de columnas menos el id, el torneo.
--Solo se puede pasar de estado Programado a En curso, de En curso a Finalizado y de Programado a Cancelado.
CREATE OR REPLACE TRIGGER trg_eventos_actualizar
BEFORE UPDATE ON Eventos
FOR EACH ROW
BEGIN
    IF :NEW.id != :OLD.id OR
    :NEW.torneo != :OLD.torneo THEN
        RAISE_APPLICATION_ERROR(-20007,'No se pueden modificar el id ni el torneo de un evento');
    END IF;
    IF :OLD.estado != :NEW.estado THEN
        IF NOT (
                (:OLD.estado = 'Programado' AND :NEW.estado IN ('En curso', 'Cancelado', 'Programado'))
                OR (:OLD.estado = 'En curso' AND :NEW.estado IN ('Finalizado', 'En curso'))
                OR (:OLD.estado = 'Finalizado' AND :NEW.estado = 'Finalizado')
            ) THEN
                RAISE_APPLICATION_ERROR(-20008, 'Solo se puede pasar de estado Programado a En curso, de En curso a Finalizado y de Programado a Cancelado');
        END IF;
    END IF;
    IF :OLD.estado != 'Programado' THEN
        IF (:NEW.fecha   != :OLD.fecha
        OR  :NEW.circuito != :OLD.circuito
        OR  :NEW.clima    != :OLD.clima
        OR  :NEW.nombre   != :OLD.nombre
        OR  :NEW.torneo   != :OLD.torneo
        OR  :NEW.id       != :OLD.id
        OR  :NEW.hora_in_game != :OLD.hora_in_game
        ) THEN
            RAISE_APPLICATION_ERROR(-20010, 'No se pueden modificar torneos que no esten en estado programado');
        END IF;
    END IF;
    IF :NEW.fecha < (SELECT fecha_inicio FROM Torneos WHERE id = :NEW.torneo) OR :NEW.fecha > (SELECT fecha_fin FROM Torneos WHERE id = :NEW.torneo) THEN
        RAISE_APPLICATION_ERROR(-20009, 'La fecha del evento debe estar dentro del calendario del torneo');
    END IF;
    IF NOT (:NEW.circuito IN (SELECT circuito FROM CircuitosDisponibles WHERE juego = (SELECT juego FROM Torneos WHERE id = torneo)))
        OR NOT (:NEW.clima IN (SELECT clima FROM CircuitosDisponibles WHERE circuito = :NEW.circuito AND juego = (SELECT juego FROM Torneos WHERE id = torneo))) THEN
        RAISE_APPLICATION_ERROR(-20011, 'Circuito o condiciones climaticas del circuito no disponibles en el juego del torneo');
    END IF; 
END;
/
--Si por lo menos un evento esta en curso o uno programado y uno finalizado, el torneo pasa a estar en curso.
--Si todos los eventos pasan a estar finalizados o cancelados, se finaliza el torneo.
--Si todos los eventos pasan a estar cancelados, se cancela el torneo.
CREATE OR REPLACE TRIGGER trg_eventos_actualizar_torneo
AFTER UPDATE ON Eventos
FOR EACH ROW
DECLARE
    num_programado  NUMBER;
    num_encurso     NUMBER;
    num_finalizado  NUMBER;
    num_cancelado   NUMBER;
BEGIN
    SELECT
        SUM(CASE WHEN estado = 'Programado' THEN 1 ELSE 0 END),
        SUM(CASE WHEN estado = 'En curso' THEN 1 ELSE 0 END),
        SUM(CASE WHEN estado = 'Finalizado' THEN 1 ELSE 0 END),
        SUM(CASE WHEN estado = 'Cancelado' THEN 1 ELSE 0 END)
    INTO num_programado, num_encurso, num_finalizado, num_cancelado
    FROM Eventos
    WHERE torneo = :NEW.torneo;
    IF num_encurso > 0 THEN
        UPDATE Torneos SET estado = 'En curso' WHERE id = :NEW.torneo;
    ELSIF num_programado > 0 AND num_finalizado > 0 THEN
        UPDATE Torneos SET estado = 'En curso' WHERE id = :NEW.torneo;
    ELSIF num_finalizado > 0 AND num_programado = 0 AND num_encurso = 0 THEN
        UPDATE Torneos SET estado = 'Finalizado' WHERE id = :NEW.torneo;
    ELSIF num_cancelado > 0 AND num_programado = 0 AND num_encurso = 0 AND num_finalizado = 0 THEN
        UPDATE Torneos SET estado = 'Cancelado' WHERE id = :NEW.torneo;
    END IF;
END;
/
