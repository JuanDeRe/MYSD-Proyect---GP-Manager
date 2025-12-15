--Disparadores No OK
-- Intentar cambiar ID de usuario
UPDATE Usuarios SET id = 'NUE0000000' WHERE id = 'ADM0000000';

-- Intentar cambiar nombre de usuario
UPDATE Usuarios SET nombre_usuario = 'NuevoNombre' WHERE id = 'ADM0000000';

-- Torneo con fecha pasada
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, organizador, juego)
VALUES ('Torneo Pasado', SYSDATE-10, SYSDATE-5, 20, 'PC', 'ADM0000000', 'F1 2025');

-- Cambiar estado de torneo inválido
UPDATE Torneos SET estado = 'Finalizado' WHERE estado = 'Programado';

-- Cambiar fecha de torneo
UPDATE Torneos SET fecha_inicio = SYSDATE+20 WHERE nombre = 'Gran Premio Colombia';

-- Intentar eliminar torneo
DELETE FROM Torneos WHERE id = 'ADM00000000000000001';

-- Evento fuera de rango de fechas del torneo
ALTER TRIGGER trg_torneos_actualizar_estado DISABLE;
UPDATE Torneos SET estado = 'Programado' WHERE nombre = 'Gran Premio Colombia';
ALTER TRIGGER trg_torneos_actualizar_estado ENABLE;

INSERT INTO Eventos (fecha, clima, hora_in_game, circuito, torneo)
SELECT SYSDATE+20, 'Despejado', '14:00', 'Monza', id
FROM Torneos WHERE nombre = 'Gran Premio Colombia';

-- Evento en torneo no programado
UPDATE Torneos SET estado = 'En curso' WHERE id = 'ADM00000000000000001';

INSERT INTO Eventos (fecha, clima, hora_in_game, circuito, torneo)
SELECT SYSDATE+5, 'Despejado', '14:00', 'Monza', id
FROM Torneos WHERE nombre = 'Gran Premio Colombia';

-- Cambiar ID de evento
UPDATE Eventos SET id = 999 WHERE id = 1 AND torneo = 'ADM00000000000000001';

-- Cambio de estado de evento inválido
ALTER TRIGGER trg_eventos_actualizar DISABLE;
UPDATE Eventos SET estado = 'Programado' WHERE id = 1 AND torneo = 'ADM00000000000000001';
ALTER TRIGGER trg_eventos_actualizar ENABLE;
UPDATE Eventos SET estado = 'Finalizado' WHERE id = 1 AND torneo = 'ADM00000000000000001';

-- Intentar eliminar evento
DELETE FROM Eventos WHERE id = 1 AND torneo = 'ADM00000000000000001';

-- Evento duplicado como carrera y clasificación
INSERT INTO Clasificaciones (id, torneo, duracion)
VALUES (1, 'ADM00000000000000001', '00:20');

-- Evento duplicado como clasificación y práctica
INSERT INTO Practicas (id, torneo, duracion)
VALUES (2, 'ADM00000000000000001', '00:30');

-- Actualizar carrera cuando evento no está programado
UPDATE Eventos SET estado = 'En curso' WHERE id = 1 AND torneo = 'ADM00000000000000001';

UPDATE Carreras SET numero_vueltas = 50 WHERE id = 1 AND torneo = 'ADM00000000000000001';

-- Actualizar clasificación cuando evento no está programado
UPDATE Eventos SET estado = 'En curso' WHERE id = 2 AND torneo = 'ADM00000000000000001';

UPDATE Clasificaciones SET duracion = '00:30' WHERE id = 2 AND torneo = 'ADM00000000000000001';

-- Actualizar práctica cuando evento no está programado
ALTER TRIGGER trg_torneos_actualizar_estado DISABLE;
UPDATE Torneos SET estado = 'Programado' WHERE id = 'ADM00000000000000001';
ALTER TRIGGER trg_torneos_actualizar_estado ENABLE;

INSERT INTO Eventos (fecha, clima, hora_in_game, circuito, torneo)
SELECT SYSDATE+6, 'Despejado', '13:00', 'Monza', id
FROM Torneos WHERE nombre = 'Gran Premio Colombia';

INSERT INTO Practicas (id, torneo, duracion)
VALUES (3, 'ADM00000000000000001', '00:45');

UPDATE Eventos SET estado = 'En curso' WHERE id = 3 AND torneo = 'ADM00000000000000001';

UPDATE Practicas SET duracion = '01:00' WHERE id = 3 AND torneo = 'ADM00000000000000001';

-- Modificar evento cuando no está programado
UPDATE Eventos SET circuito = 'NuevoCircuito' WHERE id = 1 AND torneo = 'ADM00000000000000001';