-- ORGANIZADOR
GRANT rol_organizador TO bd1000100587;

-- Adicionar un organizador
BEGIN
    pk_organizador.organizadorAdicionar('juan_ramirez', 'Colombia', 'juan@mail.com');
END;
/

-- Adicionar un torneo
BEGIN
    pk_organizador.torneoAdicionar('Gran Premio Nacional 2026', TO_DATE('2026-03-01', 'YYYY-MM-DD'), TO_DATE('2026-03-10', 'YYYY-MM-DD'), 32, 'PlayStation', 'Gran Turismo 7', 'juan_ramirez');
END;
/

-- Adicionar un evento
BEGIN
    pk_organizador.eventoAdicionar( 'Gran Premio Nacional 2026', 'Gran Turismo 7', TO_DATE('2026-03-05 14:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Spa-Francorchamps'
    );
END;
/

-- Adicionar una carrera
BEGIN
    pk_organizador.carreraAdicionar('Gran Premio Nacional 2026', 'Gran Turismo 7', TO_DATE('2026-03-06 14:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Spa-Francorchamps', 25);
END;
/

-- Adicionar una clasificación
BEGIN
    pk_organizador.clasificacionAdicionar('Gran Premio Nacional 2026', 'Gran Turismo 7', TO_DATE('2026-03-07 12:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '12:00', 'Spa-Francorchamps', '00:15');
END;
/

-- Modificar un torneo
BEGIN
    pk_organizador.torneoAdicionar('TorneoPrueba', TO_DATE('2026-08-01', 'YYYY-MM-DD'), TO_DATE('2026-08-10', 'YYYY-MM-DD'), 16, 'PC', 'Gran Turismo 7', 'juan_ramirez');
END;
/

BEGIN
    pk_organizador.torneoModificar('TorneoPrueba', 'Gran Turismo 7', 40, 'En curso');
END;
/


-- Consultar vehículos de un torneo
DECLARE
    v_cursor SYS_REFCURSOR;
    v_torneo_id VARCHAR2(20);
BEGIN
    SELECT id INTO v_torneo_id FROM torneos WHERE nombre = 'Gran Premio Nacional 2026';
    v_cursor := pk_organizador.consultarVehiculosTorneo(v_torneo_id);
    CLOSE v_cursor;
END;
/

-- Consultar circuitos de un torneo
DECLARE
    v_cursor SYS_REFCURSOR;
    v_torneo_id VARCHAR2(20);
BEGIN
    SELECT id INTO v_torneo_id FROM torneos WHERE nombre = 'Gran Premio Nacional 2026';
    v_cursor := pk_organizador.consultarCircuitosTorneo(v_torneo_id);
    CLOSE v_cursor;
END;
/

-- Consultar detalles de un torneo
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    v_cursor := pk_organizador.consultarDetallesTorneo('RAC00000000000000000');
    CLOSE v_cursor;
END;
/

REVOKE rol_organizador FROM bd1000100587;

-- DESARROLLADOR
GRANT rol_desarrollador TO bd1000100587;

-- Adicionar un vehículo
BEGIN
    pk_desarrollador.vehiculoAdicionar('Porsche', '911 GT3', 2023, 'Deportivo', 1430, 510, 'Gran Turismo 7');
END;
/

-- Adicionar otro vehículo
BEGIN
    pk_desarrollador.vehiculoAdicionar('McLaren', '720S GT3', 2019, 'Gran Turismo', 1245, 720, 'Gran Turismo 7');
END;
/

-- Adicionar un circuito
BEGIN
    pk_desarrollador.circuitoAdicionar('Autódromo de Tocancipá', 'Colombia', 5.148, 'Gran Turismo 7', 'Despejado');
END;
/

-- Adicionar otro circuito
BEGIN
    pk_desarrollador.circuitoAdicionar('Spa-Francorchamps', 'Bélgica', 3.602, 'Gran Turismo 7', 'Nublado');
END;
/

-- Adicionar un juego
BEGIN
    pk_desarrollador.juegoAdicionar('Forza Motorsport 8');
END;
/

-- Adicionar otro juego
BEGIN
    pk_desarrollador.juegoAdicionar('iRacing');
END;
/

REVOKE rol_desarrollador FROM bd1000100587;

-- JUGADOR
GRANT rol_jugador TO bd1000100587;

-- Consultar eventos de un torneo
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    v_cursor := pk_jugador.consultarEventosTorneo('RAC00000000000000000');
    CLOSE v_cursor;
END;
/

-- Consultar vehículos de un juego
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    v_cursor := pk_jugador.consultarVehiculosJuego('Gran Turismo 7');
    CLOSE v_cursor;
END;
/

-- Consultar circuitos de un juego
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    v_cursor := pk_jugador.consultarCircuitosJuego('F1 2025');
    CLOSE v_cursor;
END;
/

-- Consultar detalles de un torneo
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    v_cursor := pk_jugador.consultarDetallesTorneo('RAC00000000000000000');
    CLOSE v_cursor;
END;
/

REVOKE rol_jugador FROM bd1000100587;