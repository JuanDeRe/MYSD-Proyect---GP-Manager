-- Consultas masivas
-- Porcentaje de usuarios que son organizadores
SELECT 
    ROUND((COUNT(o.id) * 100.0 / COUNT(u.id)), 2) as porcentaje_organizadores,
    COUNT(o.id) as total_organizadores,
    COUNT(u.id) as total_usuarios
FROM Usuarios u
LEFT JOIN Organizadores o ON u.id = o.id;

-- Distribución de torneos por plataforma
SELECT 
    plataforma_principal,
    COUNT(*) as cantidad,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Torneos)), 2) as porcentaje
FROM Torneos
GROUP BY plataforma_principal
ORDER BY cantidad DESC;

-- Torneos por organizador (top 10)
SELECT 
    u.nombre_usuario,
    COUNT(t.id) as torneos_creados,
    ROUND((COUNT(t.id) * 100.0 / (SELECT COUNT(*) FROM Torneos)), 2) as porcentaje_total
FROM Organizadores o
JOIN Usuarios u ON o.id = u.id
JOIN Torneos t ON o.id = t.organizador
GROUP BY u.nombre_usuario
ORDER BY torneos_creados DESC
FETCH FIRST 10 ROWS ONLY;

-- Eventos por tipo (carrera, clasificación, práctica)
SELECT 
    'Carreras' as tipo_evento,
    COUNT(*) as cantidad
FROM Carreras
UNION ALL
SELECT 
    'Clasificaciones',
    COUNT(*)
FROM Clasificaciones
UNION ALL
SELECT 
    'Prácticas',
    COUNT(*)
FROM Practicas;

-- Distribución de climas en eventos
SELECT 
    clima,
    COUNT(*) as cantidad,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Eventos)), 2) as porcentaje
FROM Eventos
GROUP BY clima
ORDER BY cantidad DESC;

-- Usuarios por país (top 10)
SELECT 
    pais,
    COUNT(*) as cantidad,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Usuarios)), 2) as porcentaje
FROM Usuarios
GROUP BY pais
ORDER BY cantidad DESC
FETCH FIRST 10 ROWS ONLY;

-- Densidad de torneos en el tiempo (por mes)
SELECT 
    TO_CHAR(fecha_inicio, 'YYYY-MM') as mes,
    COUNT(*) as torneos_iniciados
FROM Torneos
GROUP BY TO_CHAR(fecha_inicio, 'YYYY-MM')
ORDER BY mes;