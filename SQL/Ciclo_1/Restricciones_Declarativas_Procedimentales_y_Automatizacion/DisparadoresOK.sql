--Disparadores OK
-- Usuario que sera organizador
INSERT INTO Usuarios (nombre_usuario, correo, pais)
VALUES ('AdminGT', 'admin@example.com', 'Colombia');

-- Convertirlo en organizador
INSERT INTO Organizadores (id) 
SELECT id FROM Usuarios WHERE nombre_usuario = 'AdminGT';

-- Crear torneos futuros validos
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, organizador, juego)
SELECT 'Gran Premio Colombia', SYSDATE+4, SYSDATE+7, 20, 'PC', id, 'F1 2025'
FROM Usuarios WHERE nombre_usuario = 'AdminGT';

INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, organizador, juego)
SELECT 'Gran Premio Medellin', SYSDATE+10, SYSDATE+11, 24, 'PC', id, 'F1 2025'
FROM Usuarios WHERE nombre_usuario = 'AdminGT';


-- Evento correcto dentro del torneo
INSERT INTO Eventos (fecha, clima, hora_in_game, circuito, torneo)
SELECT SYSDATE+5, 'Despejado', '14:00', 'Monza', id
FROM Torneos WHERE nombre = 'Gran Premio Colombia';
INSERT INTO Eventos (fecha, clima, hora_in_game, circuito, torneo)
SELECT SYSDATE+6, 'Despejado', '14:00', 'Monza', id
FROM Torneos WHERE nombre = 'Gran Premio Colombia';

-- Carrera
INSERT INTO Carreras (id, torneo, numero_vueltas)
VALUES ('0001', (SELECT id FROM Torneos WHERE nombre = 'Gran Premio Colombia'), 30);

-- Clasificación
INSERT INTO Clasificaciones (id, torneo, duracion)
VALUES ('0002', (SELECT id FROM Torneos WHERE nombre = 'Gran Premio Colombia'), '00:20');

SELECT * FROM Usuarios;
SELECT * FROM Organizadores;
SELECT * FROM Torneos;
SELECT * FROM Eventos;
SELECT * FROM Carreras;
SELECT * FROM Clasificaciones;
SELECT * FROM Practicas;

-- Actualizar correo y pais de un usuario
UPDATE Usuarios
SET correo = 'admin_updated@example.com', pais = 'Chile'
WHERE id = 'ADM0000000';

SELECT correo, pais FROM Usuarios
WHERE id = 'ADM0000000';

-- Actualizar fecha de evento programado con torneo programado
UPDATE Eventos
SET fecha = fecha-1
WHERE id = 1 AND torneo = 'ADM00000000000000001';

-- Actualizar el numero de vueltas de una carrera programada
UPDATE Carreras
SET numero_vueltas = 10
WHERE id = 1 AND torneo = 'ADM00000000000000001';

SELECT e.fecha,ca.numero_vueltas FROM Eventos e
JOIN Carreras ca ON e.id = ca.id AND ca.torneo = e.torneo
WHERE ca.id = 1 AND ca.torneo = 'ADM00000000000000001';

-- Si se cambia el estado de un evento a en curso, el torneo pasa a estar en curso
UPDATE Eventos
SET estado = 'En curso'
WHERE id = 1 AND torneo = 'ADM00000000000000001';

SELECT id, estado FROM Torneos
WHERE id = 'ADM00000000000000001';