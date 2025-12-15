-- VISTAS PARA MANAGER

-- Vista: Inscripciones por torneo
CREATE OR REPLACE VIEW v_inscripciones_por_torneo AS
SELECT 
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    t.cupo,
    t.estado AS torneo_estado,
    t.fecha_inicio,
    t.fecha_fin,
    t.plataforma_principal,
    u.nombre_usuario AS organizador_nombre,
    t.juego
FROM Torneos t
JOIN Organizadores o ON t.organizador = o.id
JOIN Usuarios u ON o.id = u.id;

-- Vista: Estadísticas globales por carrera
CREATE OR REPLACE VIEW v_estadisticas_carreras AS
SELECT 
    j.nombre AS juego,
    COUNT(DISTINCT t.id) AS total_torneos,
    COUNT(DISTINCT ca.id) AS total_carreras,
    ROUND(AVG(ca.numero_vueltas), 2) AS promedio_vueltas,
    MIN(ca.numero_vueltas) AS minimo_vueltas,
    MAX(ca.numero_vueltas) AS maximo_vueltas
FROM Juegos j
LEFT JOIN Torneos t ON j.nombre = t.juego
LEFT JOIN Carreras ca ON t.id = ca.torneo
GROUP BY j.nombre;

-- Vista: Torneos por organizador con métricas
CREATE OR REPLACE VIEW v_torneos_por_organizador AS
SELECT 
    u.id AS organizador_id,
    u.nombre_usuario AS organizador_nombre,
    u.pais AS organizador_pais,
    o.total_torneos_creados,
    COUNT(DISTINCT t.id) AS torneos_activos,
    COUNT(DISTINCT CASE WHEN t.estado = 'Programado' THEN t.id END) AS torneos_programados,
    COUNT(DISTINCT CASE WHEN t.estado = 'En curso' THEN t.id END) AS torneos_en_curso,
    COUNT(DISTINCT CASE WHEN t.estado = 'Finalizado' THEN t.id END) AS torneos_finalizados,
    COUNT(DISTINCT CASE WHEN t.estado = 'Cancelado' THEN t.id END) AS torneos_cancelados
FROM Usuarios u
JOIN Organizadores o ON u.id = o.id
LEFT JOIN Torneos t ON o.id = t.organizador
GROUP BY u.id, u.nombre_usuario, u.pais, o.total_torneos_creados;




-- VISTAS PARA JUGADOR

-- Vista: Eventos de torneo con detalles completos
CREATE OR REPLACE VIEW v_eventos_torneos_detalle AS
SELECT 
    e.id AS evento_id,
    e.fecha AS evento_fecha,
    e.clima AS evento_clima,
    e.hora_in_game AS evento_hora,
    e.estado AS evento_estado,
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    t.juego AS torneo_juego,
    c.nombre AS circuito_nombre,
    c.pais AS circuito_pais,
    c.longitud AS circuito_longitud,
    CASE 
        WHEN ca.id IS NOT NULL THEN 'Carrera'
        WHEN cl.id IS NOT NULL THEN 'Clasificacion'
        WHEN p.id IS NOT NULL THEN 'Practica'
        ELSE 'Sin definir'
    END AS tipo_evento,
    ca.numero_vueltas,
    cl.duracion AS duracion_clasificacion,
    p.duracion AS duracion_practica
FROM Eventos e
JOIN Torneos t ON e.torneo = t.id
JOIN Circuitos c ON e.circuito = c.nombre
LEFT JOIN Carreras ca ON e.id = ca.id AND e.torneo = ca.torneo
LEFT JOIN Clasificaciones cl ON e.id = cl.id AND e.torneo = cl.torneo
LEFT JOIN Practicas p ON e.id = p.id AND e.torneo = p.torneo;

-- Vista: Vehículos disponibles por juego con detalles
CREATE OR REPLACE VIEW v_vehiculos_por_juego AS
SELECT 
    j.nombre AS juego,
    v.marca,
    v.referencia,
    v.año,
    v.categoria,
    v.peso,
    v.hp
FROM VehiculosDeJuegos vj
JOIN Juegos j ON vj.juego = j.nombre
JOIN Vehiculos v ON vj.marca_vehiculo = v.marca 
    AND vj.referencia_vehiculo = v.referencia
ORDER BY j.nombre, v.marca, v.referencia;

-- Vista: Circuitos disponibles por juego
CREATE OR REPLACE VIEW v_circuitos_por_juego AS
SELECT 
    j.nombre AS juego,
    c.nombre AS circuito,
    c.pais,
    c.longitud,
    cd.clima
FROM CircuitosDisponibles cd
JOIN Juegos j ON cd.juego = j.nombre
JOIN Circuitos c ON cd.circuito = c.nombre
ORDER BY j.nombre, c.nombre, cd.clima;


-- VISTAS PARA ORGANIZADOR

-- Vista: Vehículos de torneo específico
CREATE OR REPLACE VIEW v_vehiculos_torneo AS
SELECT 
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    v.marca,
    v.referencia,
    v.año,
    v.categoria,
    v.peso,
    v.hp
FROM VehiculosPorTorneo vt
JOIN Torneos t ON vt.torneo = t.id
JOIN Vehiculos v ON vt.marca_vehiculo = v.marca 
    AND vt.referencia_vehiculo = v.referencia;

-- Vista: Circuitos usados en torneo
CREATE OR REPLACE VIEW v_circuitos_torneo AS
SELECT DISTINCT
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    c.nombre AS circuito_nombre,
    c.pais AS circuito_pais,
    c.longitud AS circuito_longitud,
    COUNT(e.id) AS veces_usado
FROM Torneos t
JOIN Eventos e ON t.id = e.torneo
JOIN Circuitos c ON e.circuito = c.nombre
GROUP BY t.id, t.nombre, c.nombre, c.pais, c.longitud;

-- Vista: Resumen de torneo para organizador
CREATE OR REPLACE VIEW v_resumen_torneo_organizador AS
SELECT 
    t.id AS torneo_id,
    t.nombre AS torneo_nombre,
    t.estado AS torneo_estado,
    t.fecha_inicio,
    t.fecha_fin,
    t.cupo,
    t.numero_eventos,
    u.nombre_usuario AS organizador,
    t.juego,
    COUNT(DISTINCT e.id) AS eventos_totales,
    COUNT(DISTINCT CASE WHEN e.estado = 'Programado' THEN e.id END) AS eventos_programados,
    COUNT(DISTINCT CASE WHEN e.estado = 'En curso' THEN e.id END) AS eventos_en_curso,
    COUNT(DISTINCT CASE WHEN e.estado = 'Finalizado' THEN e.id END) AS eventos_finalizados,
    COUNT(DISTINCT CASE WHEN e.estado = 'Cancelado' THEN e.id END) AS eventos_cancelados
FROM Torneos t
JOIN Organizadores o ON t.organizador = o.id
JOIN Usuarios u ON o.id = u.id
LEFT JOIN Eventos e ON t.id = e.torneo
GROUP BY t.id, t.nombre, t.estado, t.fecha_inicio, t.fecha_fin, 
         t.cupo, t.numero_eventos, u.nombre_usuario, t.juego;



-- VISTAS ESTADÍSTICAS GENERALES


CREATE OR REPLACE VIEW v_torneos_por_plataforma AS
SELECT 
    plataforma_principal,
    COUNT(*) AS total_torneos,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Torneos), 2) AS porcentaje,
    COUNT(DISTINCT organizador) AS organizadores_diferentes
FROM Torneos
GROUP BY plataforma_principal
ORDER BY total_torneos DESC;


-- Vista: Actividad mensual de torneos
CREATE OR REPLACE VIEW v_actividad_mensual_torneos AS
SELECT 
    TO_CHAR(fecha_inicio, 'YYYY-MM') AS mes,
    COUNT(*) AS torneos_iniciados,
    COUNT(DISTINCT organizador) AS organizadores_activos,
    SUM(cupo) AS cupo_total
FROM Torneos
GROUP BY TO_CHAR(fecha_inicio, 'YYYY-MM')
ORDER BY mes DESC;

-- Vista: Circuitos más utilizados
CREATE OR REPLACE VIEW v_circuitos_mas_usados AS
SELECT 
    c.nombre AS circuito,
    c.pais,
    c.longitud,
    COUNT(e.id) AS veces_usado,
    COUNT(DISTINCT e.torneo) AS torneos_diferentes,
    COUNT(DISTINCT CASE WHEN e.estado = 'Finalizado' THEN e.id END) AS eventos_finalizados
FROM Circuitos c
LEFT JOIN Eventos e ON c.nombre = e.circuito
GROUP BY c.nombre, c.pais, c.longitud
ORDER BY veces_usado DESC;

-- Vista: Juegos más populares
CREATE OR REPLACE VIEW v_juegos_populares AS
SELECT 
    j.nombre AS juego,
    COUNT(DISTINCT t.id) AS total_torneos,
    COUNT(DISTINCT t.organizador) AS organizadores_diferentes,
    SUM(t.numero_eventos) AS eventos_totales,
    COUNT(DISTINCT cd.circuito) AS circuitos_disponibles,
    COUNT(DISTINCT vj.marca_vehiculo || vj.referencia_vehiculo) AS vehiculos_disponibles
FROM Juegos j
LEFT JOIN Torneos t ON j.nombre = t.juego
LEFT JOIN CircuitosDisponibles cd ON j.nombre = cd.juego
LEFT JOIN VehiculosDeJuegos vj ON j.nombre = vj.juego
GROUP BY j.nombre
ORDER BY total_torneos DESC;