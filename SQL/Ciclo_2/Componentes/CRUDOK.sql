-- Prueba Mantener Jugador
-- Adicionar jugador
BEGIN
PK_MANTENER_JUGADOR.JugadorAdicionar(
    p_nombre_usuario => 'Piastri',
    p_correo => 'holahola@gmail.com',
    p_pais => 'Austria'
);
PK_MANTENER_JUGADOR.JugadorAdicionar(
    p_nombre_usuario => 'Norris',
    p_correo => 'norris@gmail.com',
    p_pais => 'Reino Unido'
);
END;
/
--Modificar jugador
BEGIN
PK_MANTENER_JUGADOR.JugadorModificar(
    p_nombre_usuario => 'Piastri',
    p_correo => 'mclaren123@gmail.com',
    p_pais => 'Australia'
);
END;
/
--Eliminar jugador
BEGIN
PK_MANTENER_JUGADOR.JugadorEliminar(
    p_nombre_usuario => 'Norris'
);
END;
/
-- Prueba registrar Inscripcion
-- Set Torneo F1 2026
BEGIN
PK_REGISTRAR_TORNEO.TorneoAdicionar(
    p_nombre => 'Torneo f1',
    p_juego => 'F1 2025',
    p_fecha_inicio => TO_DATE('2026-06-10', 'YYYY-MM-DD'),
    p_fecha_fin => TO_DATE('2026-06-11', 'YYYY-MM-DD'),
    p_cupo => 20,
    p_plataforma_principal => 'PC',
    p_organizador => 'Verstappen'
);

PK_REGISTRAR_CARRERA.CarreraAdicionar(
    p_torneo => 'Torneo f1',
    p_juego => 'F1 2025',
    p_fecha => TO_DATE('2026-06-10 09:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '14:00',
    p_circuito => 'Monza',
    p_numero_vueltas => 78
);

END;
/


--Adicionar inscripcion
BEGIN
PK_REGISTRAR_INSCRIPCION.InscripcionAdicionar(
    p_jugador => 'Piastri',
    p_torneo => 'Torneo f1',
    p_juego => 'F1 2025',
    p_marca_vehiculo => 'Red Bull',
    p_referencia_vehiculo => 'RB21',
    p_fecha => TO_DATE('2026-06-09', 'YYYY-MM-DD')
);
END;
/
-- Prueba Mantener Inscripcion
--Modificar inscripcion
BEGIN
PK_MANTENER_INSCRIPCION.InscripcionModificar(
    p_jugador => 'Piastri',
    p_torneo => 'Torneo f1',
    p_juego => 'F1 2025',
    p_estado => 'Aceptada'
);
END;
/

-- Torneo finalizado
BEGIN
PK_REGISTRAR_TORNEO.torneoModificar(
        p_nombre => 'Torneo f1',
        p_juego => 'F1 2025',
        p_estado => 'Finalizado',
        p_cupo => 20
);
END;
/

-- Registrar resultado
BEGIN
PK_REGISTRAR_RESULTADO.ResultadoAdicionar(
    p_jugador => 'Piastri',
    p_evento => 1,
    p_torneo => 'Torneo f1',
    p_juego => 'F1 2025',
    p_estado_resultado => 'Finished',
    p_posicion_inicio => 1,
    p_posicion_final => 1,
    p_tiempo_total => 100000,
    p_mejor_vuelta => 1275100,
    p_puntos_obtenidos => 25
);
END;
/