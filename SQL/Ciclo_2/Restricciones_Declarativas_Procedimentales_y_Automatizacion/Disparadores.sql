CREATE OR REPLACE TRIGGER trg_adicionar_jugador
BEFORE INSERT ON Jugadores
FOR EACH ROW
BEGIN
    :NEW.rango := 'Novato';
END;
/

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

CREATE OR REPLACE TRIGGER trg_acrualizar_rango
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