-- Acciones OK
SELECT u.id, o.id, t.organizador, e.torneo FROM Usuarios u 
JOIN Organizadores o ON u.id = o.id
JOIN Torneos t ON o.id = t.organizador
JOIN Eventos e ON t.id = e.torneo
WHERE u.id = 'SPE00000000000000000'; 

DELETE FROM Usuarios WHERE id = 'SPE00000000000000000';
-- Al borrar un usuario se deben eliminar los organizadores asociados y sus torneos y los eventos relacionados

SELECT u.id, o.id, t.organizador, e.torneo FROM Usuarios u 
JOIN Organizadores o ON u.id = o.id
JOIN Torneos t ON o.id = t.organizador
JOIN Eventos e ON t.id = e.torneo
WHERE u.id = 'SPE00000000000000000'; 