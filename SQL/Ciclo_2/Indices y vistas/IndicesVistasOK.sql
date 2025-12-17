-- CONSULTAS PARA JUGADOR

-- Ver inscripciones propias
-- Usa: v_inscripciones_propias
SELECT torneo_nombre, juego, fecha_inscripcion, estado_inscripcion, 
       marca, referencia, fecha_inicio
FROM v_inscripciones_propias
WHERE jugador = 'RAC0000000';

-- Ver ranking propio en torneos
-- Usa: v_ranking_jugador
SELECT torneo_nombre, posicion, puntos_totales, rango, estado_torneo
FROM v_ranking_jugador
WHERE jugador = 'RAC0000000';


-- CONSULTAS PARA ORGANIZADOR

-- Ver inscripciones pendientes
-- Usa: v_inscripciones_pendientes
SELECT torneo_nombre, jugador_nombre, jugador_rango, eventos_finalizados,
       marca, referencia, fecha_inscripcion
FROM v_inscripciones_pendientes;

-- Ver top 3 de torneos finalizados
-- Usa: v_top3_torneos_finalizados
SELECT torneo_nombre, fecha_inicio, juego, posicion, jugador, rango, puntos_totales
FROM v_top3_torneos_finalizados;


-- CONSULTAS PARA MANAGER

-- Ver top 10 jugadores más activos
-- Usa: v_top10_jugadores_activos
SELECT jugador, rango, eventos_finalizados, torneos_inscritos, torneos_confirmados, pais
FROM v_top10_jugadores_activos;

-- Ver inscripciones totales por mes
-- Usa: v_inscripciones_por_mes
SELECT mes_nombre, total_inscripciones, inscripciones_aceptadas, 
       inscripciones_pendientes, jugadores_unicos, torneos_diferentes
FROM v_inscripciones_por_mes;


-- CONSULTAS QUE USAN ÍNDICES

-- Búsqueda por rango de jugador
-- Usa: idx_jugadores_rango
SELECT rango, COUNT(*) AS total_jugadores
FROM Jugadores
GROUP BY rango;

-- Buscar inscripciones por estado
-- Usa: idx_inscripciones_estado
SELECT estado, COUNT(*) AS total
FROM Inscripciones
WHERE estado = 'Pendiente'
GROUP BY estado;

-- Rankings ordenados por puntos
-- Usa: idx_rankings_puntos
SELECT r.posicion, u.nombre_usuario, r.puntos_totales
FROM Rankings r
JOIN Jugadores j ON r.jugador = j.id
JOIN Usuarios u ON j.id = u.id
WHERE r.torneo = 'RAC00000000000000000'
ORDER BY r.puntos_totales DESC;