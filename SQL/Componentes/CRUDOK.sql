-- Prueba registrar Torneo
--Adicionar torneo
BEGIN
PK_REGISTRAR_TORNEO.torneoAdicionar(
    p_nombre => 'Torneo de Prueba',
    p_fecha_inicio => TO_DATE('2024-07-01', 'YYYY-MM-DD'),
    p_fecha_fin => TO_DATE('2024-07-10', 'YYYY-MM-DD'),
    p_cupo => 16,
    p_plataforma_principal => 'PC',
    p_juego => 'F1 2024'
);
END;

PK_REGISTRAR_TORNEO.torneoAdicionar(
    p_nombre => 'Torneo Existente',
    p_fecha_inicio => TO_DATE('2024-07-01', 'YYYY-MM-DD'),
    p_fecha_fin => TO_DATE('2024-07-10', 'YYYY-MM-DD'),
    p_cupo => 50,
    p_plataforma_principal => 'Xbox',
    p_juego => 'Assetto Corsa'
);
END;
/

--Modificar torneo
BEGIN
PK_REGISTRAR_TORNEO.torneoModificar(
    p_juego => 'F1 2024',
    p_nombre => 'Torneo de Prueba',
    p_cupo => 20,
    p_estado => 'Cancelado'
);
END;
/
-- Prueba registrar Practica
--Adicionar practica
BEGIN
PK_REGISTRAR_PRACTICA.practicaAdicionar(
    p_torneo => 'Torneo Existente',
    p_juego => 'Assetto Corsa',
    p_fecha => TO_DATE('2024-07-02 14:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Soleado',
    p_hora_in_game => '14:00',
    p_circuito => 'Monza',
    p_duracion => 30
);
END;
/
--Modificar practica
BEGIN
PK_REGISTRAR_PRACTICA.practicaModificar(
    p_id => 1,
    p_torneo => 'Torneo Existente',
    p_juego => 'Assetto Corsa',
    p_fecha => TO_DATE('2024-07-03 15:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Nublado',
    p_hora_in_game => '15:00',
    p_circuito => 'Silverstone',
    p_duracion => 45
);
END;
/
-- Prueba registrar Carrera
--Adicionar carrera
BEGIN
PK_REGISTRAR_CARRERA.carreraAdicionar(
    p_torneo => 'Torneo Existente',
    p_juego => 'Assetto Corsa',
    p_fecha => TO_DATE('2024-07-04 16:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Lluvioso',
    p_hora_in_game => '16:00',
    p_circuito => 'Circuito de Prueba',
    p_numero_vueltas => 20
);
END;
/
--Modificar carrera
BEGIN
PK_REGISTRAR_CARRERA.carreraModificar(
    p_id => 2,
    p_torneo => 'Torneo Existente',
    p_juego => 'Assetto Corsa',
    p_fecha => TO_DATE('2024-07-05 17:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Soleado',
    p_hora_in_game => '17:00',
    p_circuito => 'Monaco',
    p_numero_vueltas => 25
);
END;
/
-- Prueba registrar Clasificacion
--Adicionar clasificacion
BEGIN
PK_REGISTRAR_CLASIFICACION.clasificacionAdicionar(
    p_torneo => 'Torneo Existente',
    p_juego => 'Assetto Corsa',
    p_fecha => TO_DATE('2024-07-06 18:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Nublado',
    p_hora_in_game => '18:00',
    p_circuito => 'Spa-Francorchamps',
    p_duracion => 15
);
END;
/
--Modificar clasificacion
BEGIN
PK_REGISTRAR_CLASIFICACION.clasificacionModificar(
    p_id => 3,
    p_torneo => 'Torneo Existente',
    p_juego => 'Assetto Corsa',
    p_fecha => TO_DATE('2024-07-07 19:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Lluvioso',
    p_hora_in_game => '19:00',
    p_circuito => 'Silverstone',
    p_duracion => 20
);
END;
/

-- Prueba mantener Organizador
--Adicionar organizador
BEGIN
PK_MANTENER_ORGANIZADOR.organizadorAdicionar(
    p_nombre_usuario => 'organizador1',
    p_correo => 'organizadorprueba@example.com',
    p_pais => 'Colombia'
);
END;
/
--Modificar organizador
BEGIN
PK_MANTENER_ORGANIZADOR.organizadorModificar(
    p_nombre_usuario => 'organizador1',
    p_correo => 'organizadormodificado@example.com',
    p_pais => 'Paises Bajos'
);
END;
/
--Eliminar organizador
BEGIN
PK_MANTENER_ORGANIZADOR.organizadorEliminar(
    p_nombre_usuario => 'organizador1'
);
END;
/

-- Prueba mantener Vehiculo
--Adicionar vehiculo
BEGIN
PK_MANTENER_VEHICULO.vehiculoAdicionar(
    p_marca_vehiculo => 'Ferrari',
    p_referencia_vehiculo => 'Testarrossa',
    p_a_o_vehiculo => 1985,
    p_categoria => 'Deportivo',
    p_peso => 1500,
    p_hp => 500
);
END;
/
--Modificar eliminar vehiculo
BEGIN
PK_MANTENER_VEHICULO.vehiculoEliminar(
    p_marca_vehiculo => 'Ferrari',
    p_referencia_vehiculo => 'Testarrossa'
);
END;
/

-- Prueba mantener Circuito
--Adicionar circuito
BEGIN
PK_MANTENER_CIRCUITO.circuitoAdicionar(
    p_nombre => 'Circuito de Prueba',
    p_pais => 'España',
    p_longitud => 5.5
);
END;
/
--Eliminar circuito
BEGIN
PK_MANTENER_CIRCUITO.circuitoEliminar(
    p_nombre => 'Circuito de Prueba'
);
END;
/

-- Prueba mantener Juego
--Adicionar juego
BEGIN
PK_MANTENER_JUEGO.juegoAdicionar(
    p_nombre => 'Juego de Prueba'
);
END;
/
--Eliminar juego
BEGIN
PK_MANTENER_JUEGO.juegoEliminar(
    p_nombre => 'Juego de Prueba'
);
END;
/