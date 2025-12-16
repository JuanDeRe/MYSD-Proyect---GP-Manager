-- Torneo prueba
INSERT INTO Torneos (nombre,organizador,fecha_inicio,fecha_fin,juego,cupo,plataforma_principal) VALUES 
('Torneo ciclo 2 nook','VER0000000',TO_DATE('2025-12-01','YYYY-MM-DD'),TO_DATE('2025-12-15','YYYY-MM-DD'), 'F1 2025',20,'PC');
SELECT * FROM Torneos;
INSERT INTO Eventos (torneo,fecha,clima,hora_in_game,circuito) VALUES 
('VER00000000000000005',TO_DATE('2025-12-01 12:00','YYYY-MM-DD HH24:MI'),'Despejado','14:00','Monza');
INSERT INTO Practicas (torneo,id,duracion) VALUES 
('VER00000000000000005',1,'01:00');
-- El jugador registra una inscripción, como es el dueño del torneo, se acepta automáticamente
INSERT INTO Inscripciones (jugador,torneo,marca_vehiculo,referencia_vehiculo,fecha) VALUES 
('VER0000000','VER00000000000000005','Red Bull','RB21',TO_DATE('2025-11-20','YYYY-MM-DD'));
-- Se intenta registrar una inscripcion despues de la fecha del torneo 
INSERT INTO Inscripciones (jugador,torneo,marca_vehiculo,referencia_vehiculo,fecha) VALUES 
('LEC0000000','VER00000000000000005','Mercedes','W12',TO_DATE('2026-11-21','YYYY-MM-DD'));

-- El dueño intenta cambiar el estado de una inscripcion de aceptada a rechazada lo que no es posible
UPDATE Inscripciones SET estado = 'Rechazada' WHERE jugador = 'VER0000000' AND torneo = 'VER00000000000000005';
-- Se intenta agregar el resultado de un evento que no esta en estado finalizado
INSERT INTO Resultados (jugador,evento,torneo,posicion_inicio,posicion_final,mejor_vuelta,tiempo_total,puntos_obtenidos,estado_resultado) VALUES 
('VER0000000',1,'VER00000000000000005',1,1,0115000,150000,0,'Finished');