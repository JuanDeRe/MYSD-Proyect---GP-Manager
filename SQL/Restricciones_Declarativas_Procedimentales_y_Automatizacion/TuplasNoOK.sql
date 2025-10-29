-- TuplasNoOK
INSERT INTO Torneos (id,nombre,fecha_inicio,fecha_fin,plataforma_principal,cupo,estado) VALUES
-- FechaInicio mayor a FechaFin
('TORN0000000000000002','Copa de Primavera','2024-05-10','2024-05-01','Xbox',32,'Finalizado'),
-- Estado no coincide con las fechas
('TORN0000000000000004','Torneo de Verano','2024-07-20','2024-07-30','Pc',16,'Programado');

INSERT INTO Eventos (id,nombre,fecha,torneo_id,estado) VALUES
-- Fecha no coincide con el estado
(0,'Partida Clasificatoria 2','2024-06-15','TORN0000000000000002','En curso'),
(1,'Finales','2024-08-25','TORN0000000000000003','Programado');