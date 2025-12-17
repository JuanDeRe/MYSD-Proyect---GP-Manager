-- VISTAS PARA JUGADOR

-- Torneos disponibles para inscripción
CREATE OR REPLACE VIEW v_torneos_disponibles AS
SELECT 
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    t.juego,
    t.fecha_inicio,
    t.fecha_fin,
    t.cupo,
    t.estado,
    u.nombre_usuario AS organizador,
    COUNT(i.jugador) AS inscritos_actuales
FROM Torneos t
JOIN Organizadores o ON t.organizador = o.id
JOIN Usuarios u ON o.id = u.id
LEFT JOIN Inscripciones i ON t.id = i.torneo AND i.estado = 'Aceptada'
WHERE t.estado IN ('Programado', 'En curso')
  AND t.fecha_inicio > SYSDATE
GROUP BY t.id, t.nombre, t.juego, t.fecha_inicio, t.fecha_fin, 
         t.cupo, t.estado, u.nombre_usuario
HAVING COUNT(i.jugador) < t.cupo;

-- Inscripciones propias de un jugador
CREATE OR REPLACE VIEW v_inscripciones_propias AS
SELECT 
    i.jugador,
    u.nombre_usuario AS jugador_nombre,
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    t.juego,
    i.fecha AS fecha_inscripcion,
    i.estado AS estado_inscripcion,
    v.marca,
    v.referencia,
    t.fecha_inicio,
    t.estado AS estado_torneo
FROM Inscripciones i
JOIN Jugadores j ON i.jugador = j.id
JOIN Usuarios u ON j.id = u.id
JOIN Torneos t ON i.torneo = t.id
JOIN Vehiculos v ON i.marca_vehiculo = v.marca 
    AND i.referencia_vehiculo = v.referencia;

-- Ranking de un jugador en torneos
CREATE OR REPLACE VIEW v_ranking_jugador AS
SELECT 
    r.jugador,
    u.nombre_usuario AS jugador_nombre,
    j.rango,
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    r.posicion,
    r.puntos_totales,
    t.estado AS estado_torneo
FROM Rankings r
JOIN Jugadores j ON r.jugador = j.id
JOIN Usuarios u ON j.id = u.id
JOIN Torneos t ON r.torneo = t.id;

-- Resultados de un jugador por evento en torneos
CREATE OR REPLACE VIEW v_resultados_jugador AS
SELECT 
    res.jugador,
    u.nombre_usuario AS jugador_nombre,
    t.nombre AS torneo_nombre,
    e.fecha AS fecha_evento,
    c.nombre AS circuito,
    CASE 
        WHEN ca.id IS NOT NULL THEN 'Carrera'
        WHEN cl.id IS NOT NULL THEN 'Clasificación'
        WHEN p.id IS NOT NULL THEN 'Práctica'
    END AS tipo_evento,
    res.posicion_inicio,
    res.posicion_final,
    LPAD(FLOOR(res.mejor_vuelta / 100000), 2, '0') || ':' ||
    LPAD(FLOOR(MOD(res.mejor_vuelta, 100000) / 1000), 2, '0') || '.' ||
    LPAD(MOD(res.mejor_vuelta, 1000), 3, '0') AS mejor_vuelta,
    LPAD(FLOOR(res.tiempo_total / 10000), 2, '0') || ':' ||
    LPAD(FLOOR(MOD(res.tiempo_total, 10000) / 100), 2, '0') || ':' ||
    LPAD(MOD(res.tiempo_total, 100), 2, '0') AS tiempo_total,
    res.puntos_obtenidos,
    res.estado_resultado
FROM Resultados res
JOIN Jugadores j ON res.jugador = j.id
JOIN Usuarios u ON j.id = u.id
JOIN Eventos e ON res.evento = e.id AND res.torneo = e.torneo
JOIN Torneos t ON res.torneo = t.id
JOIN Circuitos c ON e.circuito = c.nombre
LEFT JOIN Carreras ca ON e.id = ca.id AND e.torneo = ca.torneo
LEFT JOIN Clasificaciones cl ON e.id = cl.id AND e.torneo = cl.torneo
LEFT JOIN Practicas p ON e.id = p.id AND e.torneo = p.torneo;



-- VISTAS PARA ORGANIZADOR

-- Inscripciones pendientes por torneo
CREATE OR REPLACE VIEW v_inscripciones_pendientes AS
SELECT 
    i.torneo,
    t.nombre AS torneo_nombre,
    i.jugador,
    u.nombre_usuario AS jugador_nombre,
    j.rango AS jugador_rango,
    j.eventos_finalizados,
    v.marca,
    v.referencia,
    i.fecha AS fecha_inscripcion,
    i.estado
FROM Inscripciones i
JOIN Jugadores j ON i.jugador = j.id
JOIN Usuarios u ON j.id = u.id
JOIN Torneos t ON i.torneo = t.id
JOIN Vehiculos v ON i.marca_vehiculo = v.marca 
    AND i.referencia_vehiculo = v.referencia
WHERE i.estado = 'Pendiente';

-- Jugadores confirmados en un torneo
CREATE OR REPLACE VIEW v_jugadores_confirmados AS
SELECT 
    i.torneo,
    t.nombre AS torneo_nombre,
    t.estado AS estado_torneo,
    i.jugador,
    u.nombre_usuario AS jugador_nombre,
    j.rango AS jugador_rango,
    j.eventos_finalizados AS experiencia,
    v.marca || ' ' || v.referencia AS vehiculo_inscrito,
    i.fecha AS fecha_inscripcion
FROM Inscripciones i
JOIN Jugadores j ON i.jugador = j.id
JOIN Usuarios u ON j.id = u.id
JOIN Torneos t ON i.torneo = t.id
JOIN Vehiculos v ON i.marca_vehiculo = v.marca 
    AND i.referencia_vehiculo = v.referencia
WHERE i.estado = 'Aceptada'
ORDER BY i.fecha;

-- Top 3 del ranking en torneos finalizados
CREATE OR REPLACE VIEW v_top3_torneos_finalizados AS
SELECT 
    r.torneo,
    t.nombre AS torneo_nombre,
    t.fecha_inicio,
    t.fecha_fin,
    t.juego,
    r.posicion,
    u.nombre_usuario AS jugador,
    j.rango,
    r.puntos_totales
FROM Rankings r
JOIN Jugadores j ON r.jugador = j.id
JOIN Usuarios u ON j.id = u.id
JOIN Torneos t ON r.torneo = t.id
WHERE t.estado = 'Finalizado'
  AND r.posicion <= 3
ORDER BY r.torneo, r.posicion;

-- Mejores vueltas por circuito (récords históricos)
CREATE OR REPLACE VIEW v_mejores_vueltas_circuito AS
SELECT 
    c.nombre AS circuito,
    c.pais AS circuito_pais,
    c.longitud AS circuito_longitud,
    c.clima AS circuito_clima,
    LPAD(FLOOR(MIN(res.mejor_vuelta) / 100000), 2, '0') || ':' ||
    LPAD(FLOOR(MOD(MIN(res.mejor_vuelta), 100000) / 1000), 2, '0') || '.' ||
    LPAD(MOD(MIN(res.mejor_vuelta), 1000), 3, '0') AS record_vuelta,
    -- Jugador que tiene el récord
    (SELECT u.nombre_usuario 
     FROM Resultados r2
     JOIN Jugadores j2 ON r2.jugador = j2.id
     JOIN Usuarios u ON j2.id = u.id
     JOIN Eventos e2 ON r2.evento = e2.id AND r2.torneo = e2.torneo
     WHERE e2.circuito = c.nombre 
       AND r2.mejor_vuelta = MIN(res.mejor_vuelta)
       AND r2.estado_resultado = 'Finished'
       AND ROWNUM = 1
    ) AS record_jugador,
    -- Fecha del récord
    (SELECT e2.fecha
     FROM Resultados r2
     JOIN Eventos e2 ON r2.evento = e2.id AND r2.torneo = e2.torneo
     WHERE e2.circuito = c.nombre 
       AND r2.mejor_vuelta = MIN(res.mejor_vuelta)
       AND r2.estado_resultado = 'Finished'
       AND ROWNUM = 1
    ) AS fecha_record
FROM Circuitos c
LEFT JOIN Eventos e ON c.nombre = e.circuito
LEFT JOIN Resultados res ON e.id = res.evento AND e.torneo = res.torneo
WHERE res.estado_resultado = 'Finished'
  AND res.mejor_vuelta > 0
GROUP BY c.nombre, c.pais, c.longitud, c.clima
ORDER BY MIN(res.mejor_vuelta) ASC;



-- VISTAS PARA MANAGER

-- Top 5 vehículos más inscritos
CREATE OR REPLACE VIEW v_top5_vehiculos_inscritos AS
SELECT 
    v.marca,
    v.referencia,
    v.año,
    v.categoria,
    COUNT(i.jugador) AS total_inscripciones,
    COUNT(CASE WHEN i.estado = 'Aceptada' THEN 1 END) AS inscripciones_aceptadas,
    COUNT(DISTINCT i.torneo) AS torneos_diferentes,
    COUNT(DISTINCT i.jugador) AS jugadores_diferentes
FROM Vehiculos v
LEFT JOIN Inscripciones i ON v.marca = i.marca_vehiculo 
    AND v.referencia = i.referencia_vehiculo
GROUP BY v.marca, v.referencia, v.año, v.categoria
ORDER BY total_inscripciones DESC
FETCH FIRST 5 ROWS ONLY;

-- Organizador con más inscripciones en sus torneos
CREATE OR REPLACE VIEW v_organizador_mas_inscripciones AS
SELECT 
    o.id AS organizador_id,
    u.nombre_usuario AS organizador_nombre,
    u.pais AS organizador_pais,
    o.total_torneos_creados,
    COUNT(DISTINCT t.id) AS torneos_activos,
    COUNT(i.jugador) AS total_inscripciones_recibidas,
    COUNT(CASE WHEN i.estado = 'Aceptada' THEN 1 END) AS inscripciones_aceptadas,
    COUNT(CASE WHEN i.estado = 'Pendiente' THEN 1 END) AS inscripciones_pendientes,
    COUNT(CASE WHEN i.estado = 'Rechazada' THEN 1 END) AS inscripciones_rechazadas
FROM Organizadores o
JOIN Usuarios u ON o.id = u.id
LEFT JOIN Torneos t ON o.id = t.organizador
LEFT JOIN Inscripciones i ON t.id = i.torneo
GROUP BY o.id, u.nombre_usuario, u.pais, o.total_torneos_creados
ORDER BY total_inscripciones_recibidas DESC;

-- Inscripciones totales por mes
CREATE OR REPLACE VIEW v_inscripciones_por_mes AS
SELECT 
    TO_CHAR(i.fecha, 'YYYY-MM') AS mes,
    TO_CHAR(i.fecha, 'Month YYYY') AS mes_nombre,
    COUNT(*) AS total_inscripciones,
    COUNT(CASE WHEN i.estado = 'Aceptada' THEN 1 END) AS inscripciones_aceptadas,
    COUNT(CASE WHEN i.estado = 'Pendiente' THEN 1 END) AS inscripciones_pendientes,
    COUNT(CASE WHEN i.estado = 'Rechazada' THEN 1 END) AS inscripciones_rechazadas,
    COUNT(DISTINCT i.jugador) AS jugadores_unicos,
    COUNT(DISTINCT i.torneo) AS torneos_diferentes
FROM Inscripciones i
GROUP BY TO_CHAR(i.fecha, 'YYYY-MM'), TO_CHAR(i.fecha, 'Month YYYY')
ORDER BY TO_CHAR(i.fecha, 'YYYY-MM') DESC;