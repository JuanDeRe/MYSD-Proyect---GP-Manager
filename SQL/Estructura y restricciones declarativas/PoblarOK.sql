-- PoblarOk
INSERT INTO Juegos (nombre) VALUES ('Gran Turismo 7');
INSERT INTO Juegos (nombre) VALUES ('F1 2025');
INSERT INTO Juegos (nombre) VALUES ('Assetto Corsa');

INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('Spa-Francorchamps', 'Bélgica', 7.004);
INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('Monza', 'Italia', 5.793);
INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('Silverstone', 'Reino Unido', 5.891);

INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('Ferrari', '488 GTB', 2015, 'Deportivo', 1475.00, 660);
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('Porsche', '911 GT3 RS', 2020, 'Deportivo', 1430.00, 520);
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('BMW', 'E46', 2003, 'Calle', 1655.00, 168);
INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) VALUES ('Red Bull', 'RB21', 2025, 'Monoplaza', NULL, NULL);

INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('Gran Turismo 7', 'Spa-Francorchamps', 'Despejado');
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('F1 2025', 'Monza', 'Despejado');
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('F1 2025', 'Monza', 'Lluvia ligera');
INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES ('Assetto Corsa', 'Silverstone', 'Nublado');

INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('Gran Turismo 7', 'Ferrari', '488 GTB');
INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('F1 2025', 'Red Bull', 'RB21');
INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) VALUES ('Assetto Corsa', 'Porsche', '911 GT3 RS');

INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('RAC0000000', 'RacerX', 'racerx@example.com', 'España', TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('SPE0000000', 'Speedy', 'speedy@example.com', 'Francia', TO_DATE('2023-01-02', 'YYYY-MM-DD'));
INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) VALUES ('SPE0000001', 'Speeder', 'speeder@example.com', 'Italia', TO_DATE('2023-01-03', 'YYYY-MM-DD'));

INSERT INTO Organizadores (id, total_torneos_creados) VALUES ('RAC0000000', 0);
INSERT INTO Organizadores (id, total_torneos_creados) VALUES ('SPE0000000', 0);

INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('RAC00000000000000000', 'Eurocup', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-06-07', 'YYYY-MM-DD'), 20, 'PC', 'Programado', 'RAC0000000', 'F1 2025');
INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, organizador, juego) VALUES ('SPE00000000000000000', 'GT Championship', TO_DATE('2023-07-05', 'YYYY-MM-DD'), TO_DATE('2023-07-06', 'YYYY-MM-DD'), 15, 'PlayStation', 'Programado', 'SPE0000000', 'Gran Turismo 7');

INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('RAC00000000000000000', 'Red Bull', 'RB21');
INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('SPE00000000000000000', 'Ferrari', '488 GTB');
INSERT INTO VehiculosPorTorneo (torneo, marca_vehiculo, referencia_vehiculo) VALUES ('SPE00000000000000000', 'Porsche', '911 GT3 RS');

INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (0, TO_DATE('2023-06-05 20:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '14:00', 'Programado', 'RAC00000000000000000', 'Monza');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (1, TO_DATE('2023-06-06 20:00', 'YYYY-MM-DD HH24:MI'), 'Lluvia ligera', '12:00', 'Programado', 'RAC00000000000000000', 'Spa-Francorchamps');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (2, TO_DATE('2023-06-07 20:00', 'YYYY-MM-DD HH24:MI'), 'Nublado', '16:30', 'Programado', 'RAC00000000000000000', 'Silverstone');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (0, TO_DATE('2023-07-05 13:00', 'YYYY-MM-DD HH24:MI'), 'Despejado', '09:00', 'Programado', 'SPE00000000000000000', 'Spa-Francorchamps');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (1, TO_DATE('2023-07-05 15:30', 'YYYY-MM-DD HH24:MI'), 'Despejado', '10:00', 'Programado', 'SPE00000000000000000', 'Spa-Francorchamps');
INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) VALUES (2, TO_DATE('2023-07-05 16:30', 'YYYY-MM-DD HH24:MI'), 'Despejado', '15:00', 'Programado', 'SPE00000000000000000', 'Spa-Francorchamps');

INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (0, 'RAC00000000000000000', 30);
INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (1, 'RAC00000000000000000', 25);
INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (2, 'RAC00000000000000000', 50);
INSERT INTO Carreras (id, torneo, numero_vueltas) VALUES (2, 'SPE00000000000000000', 20);

INSERT INTO Clasificaciones (id, torneo, duracion) VALUES (1, 'SPE00000000000000000', '00:30');

INSERT INTO Practicas (id, torneo, duracion) VALUES (0, 'SPE00000000000000000', '01:00');