
--Modificar jugadro que no existe
BEGIN
PK_MANTENER_JUGADOR.JugadorModificar(
    p_nombre_usuario => 'Hamilton',
    p_correo => 'mclaren123@gmail.com',
    p_pais => 'Australia'
);
END;
/

--Adicionar inscripcion a torneo ya finalizado
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

-- Registrar resultado para jugador no inscrito
BEGIN
PK_REGISTRAR_RESULTADO.ResultadoAdicionar(
    p_jugador => 'Hamilton',
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
