
-- Prueba mantener Organizador
--Adicionar organizador
--Correo mal formado
BEGIN
PK_MANTENER_ORGANIZADOR.organizadorAdicionar(
    p_nombre_usuario => 'organizador1',
    p_correo => 'organizadorprueba@@example.com',
    p_pais => 'Colombia'
);
END;
/
--Modificar organizador
--usuario no existente
BEGIN
PK_MANTENER_ORGANIZADOR.organizadorModificar(
    p_nombre_usuario => 'organizador123',
    p_correo => 'organizadormodificado@example.com',
    p_pais => 'Paises Bajos'
);
END;
/



-- Prueba registrar Torneo
--Adicionar torneo
--No se puso el organizador
BEGIN
PK_REGISTRAR_TORNEO.torneoAdicionar(
    p_nombre => 'Torneo de Prueba nook',
    p_fecha_inicio => TO_DATE('2026-07-01', 'YYYY-MM-DD'),
    p_fecha_fin => TO_DATE('2026-07-10', 'YYYY-MM-DD'),
    p_cupo => 16,
    p_plataforma_principal => 'PC',
    p_juego => 'F1 2025'
);
END;
/

--Modificar torneo
--torneo no existente
BEGIN
PK_REGISTRAR_TORNEO.torneoModificar(
    p_juego => 'F1 2025',
    p_nombre => 'Torneo de Prueba nook',
    p_cupo => 20,
    p_estado => 'Cancelado'
);
END;
/
-- Prueba registrar Practica
--Adicionar practica
-- duracion en formato incorrecto
BEGIN
PK_REGISTRAR_PRACTICA.practicaAdicionar(
    p_torneo => 'Torneo Existente',
    p_juego => 'Assetto Corsa',
    p_fecha => TO_DATE('2026-07-02 14:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Nublado',
    p_hora_in_game => '14:00',
    p_circuito => 'Silverstone',
    p_duracion => 30
);
END;
/
