-- TuplasOK
INSERT INTO Torneos (id,nombre,fecha_inicio,fecha_fin,plataforma_principal,cupo,estado,organizador,juego) VALUES
-- Fechas correctas y estado correcto
('SPE00000000000000001','Copa de Invierno','2026-12-01','2026-12-10','Pc',64,'Programado','SPE0000000','F1 2025'),
('SPE00000000000000002','Torneo de Otoño','2024-09-05','2024-09-15','Playstation',16,'Finalizado','SPE0000000','Gran Turismo 7'),
('SPE00000000000000003','Gran Premio de Verano','2024-07-15','2024-07-16','Pc',32,'Finalizado','SPE0000000','Assetto Corsa');

INSERT INTO Eventos (id,nombre,fecha,torneo_id,estado) VALUES
-- Fechas correctas y estado correcto
(0,'Partida Clasificatoria 1','2026-11-01','SPE00000000000000002','Programado'),
(0,'Partida Final','2024-08-20','SPE00000000000000003','Finalizado'),
(0,'Semifinales','2024-07-10','SPE00000000000000001','Finalizado');