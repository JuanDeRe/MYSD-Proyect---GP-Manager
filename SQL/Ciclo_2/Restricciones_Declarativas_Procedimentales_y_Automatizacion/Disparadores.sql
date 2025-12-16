-- Cada jugador comienza con el rango 'Novato' al ser añadido
CREATE OR REPLACE TRIGGER trg_adicionar_jugador
BEFORE INSERT ON Jugadores
FOR EACH ROW
BEGIN
    :NEW.rango := 'Novato';
END;
/
-- Agregar resultado solo si el evento está finalizado y actualizar puntos en el ranking
CREATE OR REPLACE TRIGGER trg_adicionar_resultado
BEFORE INSERT ON Resultados
FOR EACH ROW
DECLARE
estado_evento VARCHAR2;
puntos_actuales NUMBER;
BEGIN
    SELECT estado INTO estado_evento FROM Eventos
    WHERE id = :NEW.evento AND torneo = :NEW.torneo;
    IF estado_evento != 'Finalizado' THEN
        RAISE_APPLICATION_ERROR(-20020, 'No se pueden agregar resultados a eventos no finalizados.');
    END IF;
    SELECT puntos_totales INTO puntos_actuales FROM Rankings
    WHERE jugador = :NEW.jugador AND torneo = :NEW.torneo;
    UPDATE Rankings SET puntos_totales = puntos_actuales + :NEW.puntos_obtenidos
    WHERE jugador = :NEW.jugador AND torneo = :NEW.torneo;
END;
/
-- Actualizar el rango del jugador basado en el número de eventos finalizados
CREATE OR REPLACE TRIGGER trg_actualizar_rango
AFTER INSERT ON Resultados
FOR EACH ROW
DECLARE
n_eventos NUMBER;
BEGIN
    IF :NEW.estado_resultado = 'Finished' THEN
        SELECT COUNT(*) INTO n_eventos FROM Resultados
        WHERE estado_resultado = 'Finished' AND jugador = :NEW.jugador;
        IF n_eventos >= 100 THEN
            UPDATE Jugadores SET rango = 'Leyenda' WHERE id = :NEW.jugador;
        ELSIF n_eventos >= 50 THEN
            UPDATE Jugadores SET rango = 'Pro' WHERE id = :NEW.jugador;
        ELSIF n_eventos >= 30 THEN
            UPDATE Jugadores SET rango = 'Avanzado' WHERE id = :NEW.jugador;
        ELSIF n_eventos >= 10 THEN
            UPDATE Jugadores SET rango = 'Intermedio' WHERE id = :NEW.jugador;
        END IF;
    END IF;
END;
/
-- Gestionar inscripciones y actualizar el ranking al aceptar una inscripción
CREATE OR REPLACE TRIGGER trg_registrar_inscripcion
BEFORE INSERT ON Inscripciones
FOR EACH ROW
DECLARE
organizador_torneo Organizadores.id%TYPE;
fecha_inicio_torneo Torneos.fecha_inicio%TYPE;
BEGIN
    :NEW.fecha := SYSDATE;
    SELECT fecha_inicio INTO fecha_inicio_torneo FROM Torneos
    WHERE id = :NEW.torneo;
    IF :NEW.fecha > fecha_inicio_torneo THEN
        RAISE_APPLICATION_ERROR(-20021, 'No se pueden hacer inscripciones antes de la fecha del torneo.');
    END IF;
    SELECT organizador INTO organizador_torneo FROM Torneos
    WHERE organizador = :NEW.jugador;
    IF organizador_torneo IS NOT NULL THEN
        :NEW.estado := 'Aceptada';
    ELSE
        :NEW.estado := 'Pendiente';
    END IF;
END;
/
-- Actualizar inscripciones solo si el torneo no ha comenzado
CREATE OR REPLACE TRIGGER trg_actualizar_inscripcion
BEFORE UPDATE ON Inscripciones
FOR EACH ROW
DECLARE
fecha_inicio_torneo Torneos.fecha_inicio%TYPE;
BEGIN
    IF :OLD.estado != :NEW.estado THEN
        SELECT fecha_inicio INTO fecha_inicio_torneo FROM Torneos
        WHERE id = :NEW.torneo;
        IF SYSDATE > fecha_inicio_torneo THEN
            RAISE_APPLICATION_ERROR(-20022, 'No se pueden modificar inscripciones después de la fecha de inicio del torneo.');
        END IF;
        IF :OLD.estado != 'Pendiente' THEN
            RAISE_APPLICATION_ERROR(-20023, 'Solo se puede pasar una inscripción de pendiente a aceptada o rechazada.');
        END IF;
    ELSE
         RAISE_APPLICATION_ERROR(-20023, 'Solo se puede actualizar el estado de una inscripción.');
    END IF;
END;
/
-- Al aceptar una inscripción, agregar al jugador al ranking del torneo
CREATE OR REPLACE TRIGGER trg_incripcion_ranking
AFTER UPDATE ON Inscripciones
FOR EACH ROW
BEGIN
    IF :NEW.estado = 'Aceptada' AND :OLD.estado = 'Pendiente' THEN
        INSERT INTO Rankings (jugador, torneo)
        VALUES (:NEW.jugador, :NEW.torneo);
    END IF;
END;
/
-- Asignar posición y puntos iniciales al registrar un nuevo ranking
CREATE OR REPLACE TRIGGER trg_registrar_ranking
BEFORE INSERT ON Rankings
FOR EACH ROW
DECLARE
numero_jugadores NUMBER;
BEGIN
    SELECT COUNT(*) INTO numero_jugadores FROM Rankings
    WHERE torneo = :NEW.torneo;
    :NEW.posicion := numero_jugadores + 1;
    :NEW.puntos_totales := 0;
END;
/
-- Actualizar posiciones en el ranking tras una actualización de puntos
CREATE OR REPLACE TRIGGER trg_actualizar_ranking
AFTER UPDATE ON Rankings
FOR EACH ROW
DECLARE
    v_posicion_actual NUMBER;
    v_puntos_anteriores NUMBER;
BEGIN
    v_posicion_actual := 0;    
    v_puntos_anteriores := -1;
        -- Recorrer todos los jugadores del torneo, ordenados por puntos
    FOR jugador_rec IN (
        SELECT jugador, puntos_totales
        FROM Rankings
        WHERE torneo = :NEW.torneo
        ORDER BY puntos_totales DESC
    ) LOOP
            -- Si los puntos son diferentes, aumentamos la posición
        IF jugador_rec.puntos_totales != v_puntos_anteriores THEN
            v_posicion_actual := v_posicion_actual + 1;
        END IF;
        -- Actualizar la posición del jugador actual
        UPDATE Rankings 
        SET posicion = v_posicion_actual
        WHERE jugador = jugador_rec.jugador 
        AND torneo = :NEW.torneo;
        -- Guardar puntos del jugador actual para comparar
        v_puntos_anteriores := jugador_rec.puntos_totales;
    END LOOP;
    COMMIT;
END;
/