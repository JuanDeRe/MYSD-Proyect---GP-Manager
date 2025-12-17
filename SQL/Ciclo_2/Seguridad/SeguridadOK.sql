GRANT rol_jugador TO bd1000100587;

-- Jugador se registra en la plataforma
BEGIN
    pk_jugador.jugadorAdicionar('Hamilton', 'Reino Unido', 'hamilton@racing.com');
END;
/

-- Verificar que el jugador se creó correctamente
SELECT * FROM Jugadores 
JOIN Usuarios ON Jugadores.id = Usuarios.id 
WHERE nombre_usuario = 'Hamilton';

-- Jugador modifica su perfil
BEGIN
    pk_jugador.jugadorModificar('Hamilton', 'hamilton44@racing.com', 'Reino Unido');
END;
/

-- Verificar modificación
SELECT * FROM Usuarios WHERE nombre_usuario = 'Hamilton';

-- Jugador consulta torneos disponibles para inscripción
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    v_cursor := pk_jugador.consultarTorneosDisponibles();
    CLOSE v_cursor;
END;
/

-- Jugador se inscribe a un torneo existente
BEGIN
    pk_jugador.inscripcionAdicionar(
        'Hamilton',
        'Eurocup',
        'F1 2025',
        'Mercedes',
        'W12',
        TO_DATE('2023-06-04', 'YYYY-MM-DD')
    );
END;
/

-- Verificar inscripción
SELECT * FROM Inscripciones 
JOIN Torneos ON Inscripciones.torneo = Torneos.id 
WHERE Inscripciones.jugador = (SELECT id FROM Usuarios WHERE nombre_usuario = 'Hamilton');

-- Jugador consulta sus inscripciones
DECLARE
    v_cursor SYS_REFCURSOR;
    v_jugador_id VARCHAR2(10);
BEGIN
    SELECT id INTO v_jugador_id FROM Usuarios WHERE nombre_usuario = 'Hamilton';
    v_cursor := pk_jugador.consultarInscripcionesPropias(v_jugador_id);
    CLOSE v_cursor;
END;
/

-- Jugador consulta su ranking
DECLARE
    v_cursor SYS_REFCURSOR;
    v_jugador_id VARCHAR2(10);
BEGIN
    SELECT id INTO v_jugador_id FROM Usuarios WHERE nombre_usuario = 'Hamilton';
    v_cursor := pk_jugador.consultarRankingPropio(v_jugador_id);
    CLOSE v_cursor;
END;
/

-- Jugador consulta SUS resultados
DECLARE
    v_cursor SYS_REFCURSOR;
    v_jugador_id VARCHAR2(10);
BEGIN
    SELECT id INTO v_jugador_id FROM Usuarios WHERE nombre_usuario = 'Hamilton';
    v_cursor := pk_jugador.consultarResultadosPropios(v_jugador_id);
    CLOSE v_cursor;
END;
/

-- Jugador consulta récords de un circuito
DECLARE
    v_cursor SYS_REFCURSOR;
    v_circuito VARCHAR2(20);
    v_clima VARCHAR2(15);
BEGIN
    v_cursor := pk_jugador.consultarMejoresVueltasCircuito('Monza', 'Despejado');
    CLOSE v_cursor;
END;
/

REVOKE rol_jugador FROM bd1000100587;


GRANT rol_organizador TO bd1000100587;

-- Organizador acepta una inscripción pendiente
BEGIN
    pk_organizador.inscripcionModificar(
        'Hamilton',
        'Eurocup',
        'F1 2025',
        'Aceptada'
    );
END;
/

-- Verificar que la inscripción fue aceptada
SELECT * FROM Inscripciones 
JOIN Torneos ON Inscripciones.torneo = Torneos.id
WHERE Torneos.nombre = 'Eurocup';

-- Organizador consulta inscripciones pendientes de un torneo específico
DECLARE
    v_cursor SYS_REFCURSOR;
    v_torneo_id VARCHAR2(20);
BEGIN
    SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = 'Eurocup';
    v_cursor := pk_organizador.consultarInscripcionesPendientes(v_torneo_id);
    CLOSE v_cursor;
END;
/


-- Organizador consulta jugadores confirmados de un torneo específico
DECLARE
    v_cursor SYS_REFCURSOR;
    v_torneo_id VARCHAR2(20);
BEGIN
    SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = 'Eurocup';
    v_cursor := pk_organizador.consultarJugadoresConfirmados(v_torneo_id);
    CLOSE v_cursor;
END;
/

-- Organizador registra resultado de un evento
-- Primero finalizar el evento
BEGIN
    PK_REGISTRAR_EVENTO.eventoModificar(
        0,
        'Eurocup',
        'F1 2025',
        TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'),
        'Despejado',
        '14:00',
        'Monza',
        'Finalizado'
    );
END;
/

-- Registrar resultado
BEGIN
    pk_organizador.resultadoAdicionar(
        'Hamilton',
        0,
        'Eurocup',
        'F1 2025',
        'Finished',
        1,
        1,
        153421,
        116543,
        25
    );
END;
/

-- Verificar resultado
SELECT * FROM Resultados 
JOIN Torneos ON Resultados.torneo = Torneos.id
WHERE Torneos.nombre = 'Eurocup';

-- Verificar ranking actualizado
SELECT * FROM Rankings
JOIN Torneos ON Rankings.torneo = Torneos.id
WHERE Torneos.nombre = 'Eurocup';

-- Organizador consulta top 3 de un torneo finalizado
DECLARE
    v_cursor SYS_REFCURSOR;
    v_torneo_id VARCHAR2(20);
BEGIN
    SELECT id INTO v_torneo_id FROM Torneos WHERE nombre = 'Eurocup';
    v_cursor := pk_organizador.consultarTop3Finalizados(v_torneo_id);
    CLOSE v_cursor;
END;
/

-- Organizador consulta récords de circuitos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_circuito VARCHAR2(20);
    v_clima VARCHAR2(15);
BEGIN
    v_cursor := pk_organizador.consultarMejoresVueltasCircuito(v_circuito, v_clima);
    CLOSE v_cursor;
END;
/

REVOKE rol_organizador FROM bd1000100587;
