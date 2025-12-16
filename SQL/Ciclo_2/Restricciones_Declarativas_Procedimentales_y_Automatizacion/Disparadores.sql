-- Cada jugador comienza con el rango 'Novato' al ser añadido
CREATE OR REPLACE TRIGGER trg_adicionar_jugador
BEFORE INSERT ON Jugadores
FOR EACH ROW
BEGIN
    :NEW.eventos_finalizados := 0;
    :NEW.rango := 'Novato';
END;
/
-- Actualizar el rango del jugador basado en el número de eventos finalizados
CREATE OR REPLACE TRIGGER trg_actualizar_rango
BEFORE UPDATE OF eventos_finalizados ON Jugadores
FOR EACH ROW
BEGIN
  IF :NEW.eventos_finalizados >= 100 THEN
    :NEW.rango := 'Leyenda';
  ELSIF :NEW.eventos_finalizados >= 50 THEN
    :NEW.rango := 'Pro';
  ELSIF :NEW.eventos_finalizados >= 10 THEN
    :NEW.rango := 'Avanzado';
  ELSIF :NEW.eventos_finalizados >= 5 THEN
    :NEW.rango := 'Intermedio';
  END IF;
END;
/

-- Agregar resultado solo si el evento está finalizado 
CREATE OR REPLACE TRIGGER trg_adicionar_resultado
BEFORE INSERT ON Resultados
FOR EACH ROW
DECLARE
estado_evento Eventos.estado%TYPE;
BEGIN
    SELECT estado INTO estado_evento FROM Eventos
    WHERE id = :NEW.evento AND torneo = :NEW.torneo;
    IF estado_evento != 'Finalizado' THEN
        RAISE_APPLICATION_ERROR(-20020, 'No se pueden agregar resultados a eventos no finalizados.');
    END IF;
    UPDATE Rankings SET puntos_totales = puntos_totales + :NEW.puntos_obtenidos
    WHERE jugador = :NEW.jugador AND torneo = :NEW.torneo;
END;
/
-- Incrementar el conteo de eventos finalizados para el jugador al registrar un resultado 'Finished'
CREATE OR REPLACE TRIGGER trg_incrementar_eventos
AFTER INSERT ON Resultados
FOR EACH ROW
BEGIN
  IF :NEW.estado_resultado = 'Finished' THEN
    UPDATE Jugadores
    SET eventos_finalizados = eventos_finalizados + 1
    WHERE id = :NEW.jugador;
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
    IF :NEW.fecha IS NULL THEN
        :NEW.fecha := SYSDATE;
    END IF;
    SELECT fecha_inicio INTO fecha_inicio_torneo FROM Torneos
    WHERE id = :NEW.torneo;
    IF :NEW.fecha > fecha_inicio_torneo THEN
        RAISE_APPLICATION_ERROR(-20021, 'No se pueden hacer inscripciones antes de la fecha del torneo.');
    END IF;
    SELECT organizador INTO organizador_torneo FROM Torneos
    WHERE id = :NEW.torneo;
    IF organizador_torneo = :NEW.jugador THEN
        :NEW.estado := 'Aceptada';
        INSERT INTO Rankings (jugador, torneo)
        VALUES (:NEW.jugador, :NEW.torneo);
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
        IF :NEW.fecha > fecha_inicio_torneo THEN
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
AFTER UPDATE OF puntos_totales ON Rankings
BEGIN
  -- Recalcular posiciones por torneo
  FOR t IN (SELECT DISTINCT torneo FROM Rankings) LOOP
    DECLARE
      v_pos NUMBER := 0;
      v_prev NUMBER := -1;
    BEGIN
      FOR r IN (
        SELECT jugador, puntos_totales
        FROM Rankings
        WHERE torneo = t.torneo
        ORDER BY puntos_totales DESC
      ) LOOP
        IF r.puntos_totales != v_prev THEN
          v_pos := v_pos + 1;
        END IF;

        UPDATE Rankings
        SET posicion = v_pos
        WHERE jugador = r.jugador
          AND torneo  = t.torneo;

        v_prev := r.puntos_totales;
      END LOOP;
    END;
  END LOOP;
END;
/
