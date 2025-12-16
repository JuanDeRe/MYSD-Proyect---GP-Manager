-- Un Organizador (que tambien es jugador) crea un torneo y invita a un amigo para que se inscriba
-- Crear Organuzador y jugador
BEGIN

PK_MANTENER_ORGANIZADOR.OrganizadorAdicionar(
    p_nombre_usuario => 'Russell',
    p_correo => 'russell@eyahoo.com',
    p_pais => 'Reino Unido'
);

PK_MANTENER_JUGADOR.JugadorAdicionar(
    p_nombre_usuario => 'Russell',
    p_correo => 'russell@eyahoo.com',
    p_pais => 'Reino Unido'
);

PK_MANTENER_JUGADOR.JugadorAdicionar(
    p_nombre_usuario => 'Antonelli',
    p_correo => 'antonelli@eyahoo.com',
    p_pais => 'Italia'
);
END;
/
-- Verificar que los jugadores se hayan creado
 SELECT * FROM Jugadores JOIN Usuarios 
 ON Jugadores.id = Usuarios.id 
 WHERE nombre_usuario IN ('Russell', 'Antonelli');


-- Crear torneo y sus eventos
BEGIN
PK_REGISTRAR_TORNEO.TorneoAdicionar(
    p_nombre => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_fecha_inicio => TO_DATE('2026-01-10', 'YYYY-MM-DD'),
    p_fecha_fin => TO_DATE('2026-01-12', 'YYYY-MM-DD'),
    p_cupo => 2,
    p_plataforma_principal => 'PC',
    p_organizador => 'Russell'
);

PK_REGISTRAR_CARRERA.carreraAdicionar(
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_fecha => TO_DATE('2026-01-10 16:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '16:00',
    p_circuito => 'Monza',
    p_numero_vueltas => 10
);


PK_REGISTRAR_CARRERA.carreraAdicionar(
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_fecha => TO_DATE('2026-01-11 16:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Lluvia ligera',
    p_hora_in_game => '16:00',
    p_circuito => 'Monza',
    p_numero_vueltas => 10
);
END;
/
SELECT * FROM Torneos 
WHERE nombre = 'Mini Torneo F1';
SELECT * FROM Carreras  
JOIN Eventos ON Carreras.id = Eventos.id 
JOIN Torneos ON Eventos.torneo = Torneos.id
WHERE Torneos.nombre = 'Mini Torneo F1';

-- Los jugadores se inscriben al torneo
BEGIN
PK_REGISTRAR_INSCRIPCION.InscripcionAdicionar(
    p_jugador => 'Russell',
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_marca_vehiculo => 'Mercedes',
    p_referencia_vehiculo => 'W12',
    p_fecha => TO_DATE('2026-01-09', 'YYYY-MM-DD')
);
PK_REGISTRAR_INSCRIPCION.InscripcionAdicionar(
    p_jugador => 'Antonelli',
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_marca_vehiculo => 'Mercedes',
    p_referencia_vehiculo => 'W12',
    p_fecha => TO_DATE('2026-01-09', 'YYYY-MM-DD')
);
END;
/
SELECT * FROM Inscripciones 
JOIN Torneos ON Inscripciones.torneo = Torneos.id 
WHERE Torneos.nombre = 'Mini Torneo F1';


-- EL organizador del torneo debe aceptar la inscripcion
BEGIN
PK_MANTENER_INSCRIPCION.InscripcionModificar(
    p_jugador => 'Antonelli',
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_estado => 'Aceptada'
);
END;
/
SELECT * FROM Inscripciones 
JOIN Torneos ON Inscripciones.torneo = Torneos.id 
WHERE Torneos.nombre = 'Mini Torneo F1';


-- El primer evento se lleva a cabo y se registran los resultados
BEGIN
PK_REGISTRAR_CARRERA.carreraModificar(
    p_id => 1,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_fecha => TO_DATE('2026-01-10 16:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '16:00',
    p_circuito => 'Monza',
    p_numero_vueltas => 10,
    p_estado => 'En curso'
);
PK_REGISTRAR_CARRERA.carreraModificar(
    p_id => 1,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_fecha => TO_DATE('2026-01-10 16:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '16:00',
    p_circuito => 'Monza',
    p_numero_vueltas => 10,
    p_estado => 'Finalizado'
);
PK_REGISTRAR_RESULTADO.ResultadoAdicionar(
    p_jugador => 'Russell',
    p_evento => 1,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_estado_resultado => 'Finished',
    p_posicion_inicio => 1,
    p_posicion_final => 1,
    p_tiempo_total => 100000,
    p_mejor_vuelta => 127510,
    p_puntos_obtenidos => 25
);
PK_REGISTRAR_RESULTADO.ResultadoAdicionar(
    p_jugador => 'Antonelli',
    p_evento => 1,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_estado_resultado => 'Finished',
    p_posicion_inicio => 2,
    p_posicion_final => 2,
    p_tiempo_total => 101000,
    p_mejor_vuelta => 137510,
    p_puntos_obtenidos => 18
);
END;
/
SELECT * FROM Resultados 
JOIN Torneos ON Resultados.torneo = Torneos.id
WHERE Torneos.nombre = 'Mini Torneo F1';
-- El segundo evento se lleva a cabo y se registran los resultados
BEGIN
PK_REGISTRAR_CARRERA.carreraModificar(
    p_id => 2,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_fecha => TO_DATE('2026-01-11 16:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Lluvia ligera',
    p_hora_in_game => '16:00',
    p_circuito => 'Monza',
    p_numero_vueltas => 10,
    p_estado => 'En curso'
);
PK_REGISTRAR_CARRERA.carreraModificar(
    p_id => 2,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_fecha => TO_DATE('2026-01-11 16:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Lluvia ligera',
    p_hora_in_game => '16:00',
    p_circuito => 'Monza',
    p_numero_vueltas => 10,
    p_estado => 'Finalizado'
);
PK_REGISTRAR_RESULTADO.ResultadoAdicionar(
    p_jugador => 'Russell',
    p_evento => 2,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_estado_resultado => 'Finished',
    p_posicion_inicio => 1,
    p_posicion_final => 1,
    p_tiempo_total => 110000,
    p_mejor_vuelta => 127510,
    p_puntos_obtenidos => 25
);
PK_REGISTRAR_RESULTADO.ResultadoAdicionar(
    p_jugador => 'Antonelli',
    p_evento => 2,
    p_torneo => 'Mini Torneo F1',
    p_juego => 'F1 2025',
    p_estado_resultado => 'Finished',
    p_posicion_inicio => 2,
    p_posicion_final => 2,
    p_tiempo_total => 101000,
    p_mejor_vuelta => 137100,
    p_puntos_obtenidos => 18
);
END;
/

SELECT * FROM Resultados 
JOIN Torneos ON Resultados.torneo = Torneos.id
WHERE Torneos.nombre = 'Mini Torneo F1';

-- Después del torneo, se mira el ranking para ver el ganador
SELECT * FROM Rankings 
JOIN Torneos ON Rankings.torneo = Torneos.id
WHERE Torneos.nombre = 'Mini Torneo F1';
