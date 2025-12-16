
-- Un desarrollador agrega juegos, vehiculos y circuitos a la plataforma

-- Prueba agregar juegos
BEGIN
PK_MANTENER_JUEGO.juegoAdicionar(
    p_nombre => 'Gran Turismo Sport'
);
END;
/
BEGIN
PK_MANTENER_JUEGO.juegoAdicionar(
    p_nombre => 'F1 2025'
);
END;
/

-- verificar que el juego se haya agregado correctamente
SELECT * FROM Juegos;

-- Prueba agregar Vehiculo
BEGIN
PK_MANTENER_VEHICULO.vehiculoAdicionar(
    p_marca_vehiculo => 'Ferrari',
    p_referencia_vehiculo => 'SF21',
    p_a_o_vehiculo => 2021,
    p_categoria => 'Deportivo',
    p_peso => 752,
    p_hp => 1000,
    p_juego => 'Gran Turismo Sport'
);
END;
/
-- verificar que el vehiculo se haya agregado correctamente
SELECT * FROM Vehiculos WHERE marca = 'Ferrari' AND referencia = 'SF21';
SELECT * FROM VehiculosDeJuegos WHERE juego = 'Gran Turismo Sport' AND marca_vehiculo = 'Ferrari' AND referencia_vehiculo = 'SF21';
-- Prueba agregar circuito
BEGIN
PK_MANTENER_CIRCUITO.circuitoAdicionar(
    p_nombre => 'Silverstone',
    p_pais => 'Reino Unido',
    p_longitud => 5.891,
    p_juego => 'Gran Turismo Sport',
    p_clima => 'Despejado'
);
END;
/
-- Prueba agregar el mismo circuito pero con clima diferente
BEGIN
PK_MANTENER_CIRCUITO.circuitoAdicionar(
    p_nombre => 'Silverstone',
    p_pais => 'Reino Unido',
    p_longitud => 5.891,
    p_juego => 'Gran Turismo Sport',
    p_clima => 'Lluvia ligera'
);
END;
/

-- verificar que el circuito se haya agregado correctamente
SELECT * FROM Circuitos WHERE nombre = 'Silverstone';
SELECT * FROM CircuitosDisponibles WHERE juego = 'Gran Turismo Sport' AND circuito = 'Silverstone';
-------------------------------------------------------------
-- Un usurario se regisrtra en la plataforma como organizador
-- Prueba registrar Organizador
--Adicionar organizador
BEGIN
PK_MANTENER_ORGANIZADOR.organizadorAdicionar(
    p_nombre_usuario => 'juandere16',
    p_correo => 'juandere16@gmail.com',
    p_pais => 'Colombia'
);
END;
/

-- verificar que el organizador se haya registrado correctamente
SELECT * FROM Usuarios WHERE nombre_usuario = 'juandere16';
SELECT * FROM Organizadores WHERE id = (SELECT id FROM Usuarios WHERE nombre_usuario = 'juandere16');

-- El organizador quiere cambiar su pais y correo
--Modificar organizador
BEGIN
PK_MANTENER_ORGANIZADOR.organizadorModificar(
    p_nombre_usuario => 'juandere16',
    p_correo => 'juandere16@hotmail.com',
    p_pais => 'Argentina'
);
END;
/

-- verificar que el organizador se haya modificado correctamente
SELECT * FROM Usuarios WHERE nombre_usuario = 'juandere16';

-- EL organizador quiere crear un torneo para un juego
-- Prueba registrar Torneo
--Adicionar torneo
BEGIN
PK_REGISTRAR_TORNEO.torneoAdicionar(
    p_nombre => 'Torneo de año nuevo',
    p_fecha_inicio => TO_DATE('2025-12-31', 'YYYY-MM-DD'),
    p_fecha_fin => TO_DATE('2026-01-03', 'YYYY-MM-DD'),
    p_cupo => 32,
    p_plataforma_principal => 'PC',
    p_juego => 'Gran Turismo Sport',
    p_organizador => 'juandere16'
);
END;
/
-- verificar que el torneo se haya registrado correctamente
SELECT * FROM Torneos WHERE nombre = 'Torneo de año nuevo';

-- El organizador quiere cambiar el cupo del torneo
--Modificar torneo
BEGIN
    PK_REGISTRAR_TORNEO.torneoModificar(
        p_nombre => 'Torneo de año nuevo',
        p_juego => 'Gran Turismo Sport',
        p_cupo => 20,
        p_estado => 'Programado'
    );
END;
/
-- verificar que el torneo se haya modificado correctamente
SELECT * FROM Torneos WHERE nombre = 'Torneo de año nuevo';

-- El organizador quiere agregar una practica, una clasificacion y una carrera al torneo
-- Prueba registrar Practica
--Adicionar practica
BEGIN
PK_REGISTRAR_PRACTICA.practicaAdicionar(
    p_torneo => 'Torneo de año nuevo',
    p_juego => 'Gran Turismo Sport',
    p_fecha => TO_DATE('2025-12-31 10:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '10:00',
    p_circuito => 'Silverstone',
    p_duracion => '01:00'
);
END;
/

-- adicionar clasificacion
BEGIN
PK_REGISTRAR_CLASIFICACION.clasificacionAdicionar(
    p_torneo => 'Torneo de año nuevo',
    p_juego => 'Gran Turismo Sport',
    p_fecha => TO_DATE('2025-12-31 12:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '12:00',
    p_circuito => 'Silverstone',
    p_duracion => '00:30'
);
END;
/
-- adicionar carrera
BEGIN
PK_REGISTRAR_CARRERA.carreraAdicionar(
    p_torneo => 'Torneo de año nuevo',
    p_juego => 'Gran Turismo Sport',
    p_fecha => TO_DATE('2025-12-31 15:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Lluvia ligera',
    p_hora_in_game => '15:00',
    p_circuito => 'Silverstone',
    p_numero_vueltas => 20
);
END;
/
-- verificar que la practica, clasificacion y carrera se hayan registrado correctamente
SELECT * FROM Practicas WHERE torneo = (SELECT id FROM Torneos WHERE nombre = 'Torneo de año nuevo');
SELECT * FROM Clasificaciones WHERE torneo = (SELECT id FROM Torneos WHERE nombre = 'Torneo de año nuevo');
SELECT * FROM Carreras WHERE torneo = (SELECT id FROM Torneos WHERE nombre = 'Torneo de año nuevo');

-- El organizador fue invitado a una fiesta de año nuevo y no podra organizar el torneo, por lo que quiere cambiar la fecha de los eventos
-- modificar practica
BEGIN
PK_REGISTRAR_PRACTICA.practicaModificar(
    p_id => 1,
    p_torneo => 'Torneo de año nuevo',
    p_juego => 'Gran Turismo Sport',
    p_fecha => TO_DATE('2026-01-02 10:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '11:00',
    p_circuito => 'Silverstone',
    p_duracion => '01:15'
);
END;
/
-- modificar clasificacion
BEGIN
PK_REGISTRAR_CLASIFICACION.clasificacionModificar(
    p_id => 2,
    p_torneo => 'Torneo de año nuevo',
    p_juego => 'Gran Turismo Sport',
    p_fecha => TO_DATE('2026-01-02 12:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Despejado',
    p_hora_in_game => '13:00',
    p_circuito => 'Silverstone',
    p_duracion => '00:45'
);
END;
/
-- modificar carrera
BEGIN
PK_REGISTRAR_CARRERA.carreraModificar(
    p_id => 3,
    p_torneo => 'Torneo de año nuevo',
    p_juego => 'Gran Turismo Sport',
    p_fecha => TO_DATE('2026-01-02 15:00', 'YYYY-MM-DD HH24:MI'),
    p_clima => 'Lluvia ligera',
    p_hora_in_game => '16:00',
    p_circuito => 'Silverstone',
    p_numero_vueltas => 25
);
END;
/
-- verificar que la practica, clasificacion y carrera se hayan modificado correctamente
SELECT * FROM Practicas WHERE torneo = (SELECT id FROM Torneos WHERE nombre = 'Torneo de año nuevo');
SELECT * FROM Clasificaciones WHERE torneo = (SELECT id FROM Torneos WHERE nombre = 'Torneo de año nuevo');
SELECT * FROM Carreras WHERE torneo = (SELECT id FROM Torneos WHERE nombre = 'Torneo de año nuevo');

-- Finalmente, se da cuenta que no podra organizar el torneo y decide cancelar el torneo
--Modificar torneo
BEGIN
    PK_REGISTRAR_TORNEO.torneoModificar(
        p_nombre => 'Torneo de año nuevo',
        p_juego => 'Gran Turismo Sport',
        p_cupo => 20,
        p_estado => 'Cancelado'
    );
END;
/
-- verificar que el torneo se haya modificado correctamente
SELECT * FROM Torneos WHERE nombre = 'Torneo de año nuevo';
-- verificar que los eventos asociados al torneo tambien se hayan cancelado
SELECT * FROM Eventos WHERE torneo = (SELECT id FROM Torneos WHERE nombre = 'Torneo de año nuevo');



------------------------------------------------------


