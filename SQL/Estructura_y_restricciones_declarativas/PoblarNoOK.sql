-- PoblarNoOk

-- El ID es demasiado corto.
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('INVALIDID', 'ValidUser', 'validemail@a.com', 'Nowhere', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
-- El correo electrónico no es válido.
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('VALIDID001', 'ValidUser', 'invalidemail', 'Nowhere', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
-- El nombre de usuario contiene espacios.
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('VALIDID002', 'Invalid User', 'validemail@a.com', 'Nowhere', TO_DATE('2023-01-01', 'YYYY-MM-DD'));

-- El Usuario no existe.
INSERT INTO Organizadores (id, total_torneos_creados) VALUES ('AAA0000020', 0);

-- El organizador no existe.
INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('VALIDTOURNEY001', 'Valid Tournament', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-06-15', 'YYYY-MM-DD'), 10, 'PC', 'Programado', 'AAA0000020', 'F1 2025');

-- El torneo tiene un cupo inválido.
INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('INVALIDTOURNEY', 'Bad Tournament', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-06-15', 'YYYY-MM-DD'), -1, 'PC', 'Programado', 'RAC0000000', 'F1 2025');

-- La fecha del evento es inválida.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (99, TO_DATE('2023-06-05 00:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'RAC00000000000000000', 'Monza');
-- El clima del evento es inválido.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (99, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Tormenta', '14:00', 'Programado', 'RAC00000000000000000', 'Monza');
-- El circuito no existe.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (99, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'RAC00000000000000000', 'Circuito Inexistente');
-- No se da el torneo.
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, circuito) VALUES (99, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'Monza');   

-- La duración de la clasificación es inválida.
INSERT INTO Clasificaciones (id, torneo, duracion) VALUES (99, 'SPE00000000000000000', '25:00');

-- La duración de la práctica es inválida.
INSERT INTO Practicas (id, torneo, duracion) VALUES (99, 'SPE00000000000000000', '01:60');

-- El vehículo no existe.
INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('SPE00000000000000000', 'MarcaInexistente', 'ReferenciaInexistente');

-- El juego no existe.
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('JuegoInexistente', 'Spa-Francorchamps', 'Despejado');

-- El circuito no existe.
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('F1 2025', 'CircuitoInexistente', 'Despejado');

-- El vehículo no existe.
INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('F1 2025', 'MarcaInexistente', 'ReferenciaInexistente');

-- nombre del juego es demasiado largo.
INSERT INTO Juegos (nombre) VALUES ('EsteNombreDeJuegoEsDemasiadoLargoParaSerValido');

-- La longitud del circuito es inválida.
INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('CircuitoValido', 'PaisValido', -5.0);

-- El peso del vehículo es inválido.
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('MarcaValida', 'ReferenciaValida', 2020, 'Deportivo', -1500.00, 300);
