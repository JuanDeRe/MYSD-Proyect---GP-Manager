
-- Torneo prueba
INSERT INTO Usuarios (nombre_usuario,pais) VALUES ('Verstappen','Netherlands');
INSERT INTO Organizadores (id) VALUES ('VER0000000');
INSERT INTO Usuarios (nombre_usuario,pais) VALUES ('Leclerc','Monaco');
INSERT INTO Torneos (id,nombre,organizador,fecha_inicio,fecha_fin,juego,cupo,plataforma_principal) VALUES 
('VER00000000000000003','Torneo ciclo 2','VER0000000',TO_DATE('2025-12-01','YYYY-MM-DD'),TO_DATE('2025-12-15','YYYY-MM-DD'), 'F1 2025',20,'PC');
INSERT INTO Eventos (torneo,fecha,clima,hora_in_game,circuito) VALUES 
('VER00000000000000003',TO_DATE('2025-12-01 12:00','YYYY-MM-DD HH24:MI'),'Despejado','14:00','Monza');
INSERT INTO Practicas (torneo,id,duracion) VALUES 
('VER00000000000000003',1,'01:00');
INSERT INTO Eventos (torneo,fecha,clima,hora_in_game,circuito) VALUES 
('VER00000000000000003',TO_DATE('2025-12-02 12:00','YYYY-MM-DD HH24:MI'),'Despejado','14:00','Monza');
INSERT INTO Practicas (torneo,id,duracion) VALUES 
('VER00000000000000003',2,'01:00');
INSERT INTO Eventos (torneo,fecha,clima,hora_in_game,circuito) VALUES 
('VER00000000000000003',TO_DATE('2025-12-03 12:00','YYYY-MM-DD HH24:MI'),'Despejado','14:00','Monza');
INSERT INTO Practicas (torneo,id,duracion) VALUES 
('VER00000000000000003',3,'01:00');
INSERT INTO Eventos (torneo,fecha,clima,hora_in_game,circuito) VALUES 
('VER00000000000000003',TO_DATE('2025-12-04 12:00','YYYY-MM-DD HH24:MI'),'Despejado','14:00','Monza');
INSERT INTO Clasificaciones (torneo,id,duracion) VALUES 
('VER00000000000000003',4,'01:00');
INSERT INTO Eventos (torneo,fecha,clima,hora_in_game,circuito) VALUES 
('VER00000000000000003',TO_DATE('2025-12-05 12:00','YYYY-MM-DD HH24:MI'),'Despejado','14:00','Monza');
INSERT INTO Carreras (torneo,id,numero_vueltas) VALUES 
('VER00000000000000003',5,30);
SELECT * FROM Torneos;
SELECT * FROM Eventos;
-- El jugador se inserta con rango 'Novato'
INSERT INTO Jugadores (id) VALUES ('VER0000000');
INSERT INTO Jugadores (id) VALUES ('LEC0000000');
SELECT * FROM Jugadores;

-- El jugador registra una inscripción, como es el dueño del torneo, se acepta automáticamente
INSERT INTO Inscripciones (jugador,torneo,marca_vehiculo,referencia_vehiculo,fecha) VALUES 
('VER0000000','VER00000000000000003','Red Bull','RB21',TO_DATE('2025-11-20','YYYY-MM-DD'));
-- Otro jugador registra una inscripción, queda pendiente
INSERT INTO Inscripciones (jugador,torneo,marca_vehiculo,referencia_vehiculo,fecha) VALUES 
('LEC0000000','VER00000000000000003','Mercedes','W12',TO_DATE('2025-11-21','YYYY-MM-DD'));
SELECT * FROM Inscripciones;
-- El organizador acepta la inscripción pendiente
UPDATE Inscripciones SET estado = 'Aceptada' WHERE jugador = 'LEC0000000' AND torneo = 'VER00000000000000003';
SELECT * FROM Inscripciones;
SELECT * FROM Rankings;

-- Pasan los eventos y se registran resultados
UPDATE Eventos SET estado = 'En curso' WHERE torneo = 'VER00000000000000003';
UPDATE Eventos SET estado = 'Finalizado' WHERE torneo = 'VER00000000000000003';
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('VER0000000',1,'VER00000000000000003',1,1,0115000,150000,0,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('LEC0000000',1,'VER00000000000000003',2,2,0116000,152010,0,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('VER0000000',2,'VER00000000000000003',1,1,0115000,150000,0,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('LEC0000000',2,'VER00000000000000003',2,2,0116000,152010,0,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('VER0000000',3,'VER00000000000000003',1,1,0115000,150000,0,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('LEC0000000',3,'VER00000000000000003',2,2,0116000,152010,0,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('VER0000000',4,'VER00000000000000003',1,1,0115000,150000,1,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('LEC0000000',4,'VER00000000000000003',2,2,0116000,152010,0,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('VER0000000',5,'VER00000000000000003',1,1,0115000,150000,25,'Finished');
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('LEC0000000',5,'VER00000000000000003',2,2,0116000,152010,18,'Finished');

--Se revisa el ranking donde debe estar Verstappen ganando con 26 puntos y Leclerc con 18
SELECT * FROM Rankings WHERE torneo = 'VER00000000000000003';

--Como completaron 5 eventos, ahora estan en rango Intermedio
SELECT * FROM Jugadores
WHERE id = 'VER0000000' OR id = 'LEC0000000';

