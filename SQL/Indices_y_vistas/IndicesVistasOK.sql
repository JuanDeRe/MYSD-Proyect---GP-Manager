SET SERVEROUTPUT ON;

-- 1. CONSULTAS PARA MANAGER

-- 1.1 - Obtener inscripciones de torneos programados
-- Usa: v_inscripciones_por_torneo + idx_torneos_estado
SELECT * FROM v_inscripciones_por_torneo 
WHERE torneo_estado = 'Programado'
FETCH FIRST 5 ROWS ONLY;

-- 1.2 - Ver estadísticas globales por carrera
-- Usa: v_estadisticas_carreras
SELECT * FROM v_estadisticas_carreras 
ORDER BY total_torneos DESC;

-- 1.3 - Top 10 organizadores más activos
-- Usa: v_torneos_por_organizador
SELECT organizador_nombre, organizador_pais, total_torneos_creados, torneos_activos
FROM v_torneos_por_organizador
WHERE torneos_activos > 0
ORDER BY total_torneos_creados DESC
FETCH FIRST 10 ROWS ONLY;

-- 1.4 - Comparar juegos por popularidad
-- Usa: v_juegos_populares
SELECT juego, total_torneos, organizadores_diferentes, eventos_totales
FROM v_juegos_populares
ORDER BY total_torneos DESC;


-- 2. CONSULTAS PARA JUGADOR

-- 2.1 - Conocer eventos de un torneo específico con fecha
-- Usa: v_eventos_torneos_detalle + idx_eventos_torneo_fecha
DECLARE
    v_torneo_id VARCHAR2(20);
BEGIN
    -- Obtener un torneo programado
    SELECT id INTO v_torneo_id FROM Torneos 
    WHERE estado = 'Programado' AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('Eventos del torneo: ' || v_torneo_id);
    
    FOR rec IN (
        SELECT evento_fecha, circuito_nombre, tipo_evento, evento_clima
        FROM v_eventos_torneos_detalle
        WHERE torneo_id = v_torneo_id
        ORDER BY evento_fecha
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('  - ' || rec.evento_fecha || ' | ' || 
                             rec.circuito_nombre || ' | ' || 
                             rec.tipo_evento || ' | ' || rec.evento_clima);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay torneos programados');
END;
/

-- 2.2 - Ver vehículos disponibles en un juego
-- Usa: v_vehiculos_por_juego + idx_vehjuego_juego
SELECT marca, referencia, categoria, año, hp
FROM v_vehiculos_por_juego
WHERE juego = 'F1 2025'
ORDER BY categoria, marca
FETCH FIRST 10 ROWS ONLY;

-- 2.3 - Conocer circuitos disponibles en un juego
-- Usa: v_circuitos_por_juego + idx_circdisp_juego
SELECT circuito, pais, longitud, clima
FROM v_circuitos_por_juego
WHERE juego = 'F1 2025'
ORDER BY circuito, clima
FETCH FIRST 10 ROWS ONLY;

-- 2.4 - Saber plataforma principal de torneos disponibles
-- Usa: v_torneos_plataforma
SELECT torneo_nombre, plataforma_principal, juego, fecha_inicio, cupo
FROM v_torneos_plataforma
WHERE plataforma_principal = 'PC'
ORDER BY fecha_inicio
FETCH FIRST 5 ROWS ONLY;



-- 3. CONSULTAS PARA ORGANIZADOR

-- 3.1 - Ver mis torneos con resumen completo
-- Usa: v_resumen_torneo_organizador + idx_torneos_organizador
DECLARE
    v_org_id VARCHAR2(10);
BEGIN
    -- Obtener un organizador
    SELECT id INTO v_org_id FROM Organizadores WHERE ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('Torneos del organizador: ' || v_org_id);
    
    FOR rec IN (
        SELECT torneo_nombre, torneo_estado, numero_eventos, 
               eventos_programados, eventos_en_curso, eventos_finalizados
        FROM v_resumen_torneo_organizador
        WHERE organizador = (SELECT nombre_usuario FROM Usuarios WHERE id = v_org_id)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('  ' || rec.torneo_nombre || ' [' || rec.torneo_estado || ']');
        DBMS_OUTPUT.PUT_LINE('    Eventos: ' || rec.numero_eventos || 
                             ' (P:' || rec.eventos_programados || 
                             ', C:' || rec.eventos_en_curso || 
                             ', F:' || rec.eventos_finalizados || ')');
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay organizadores');
END;
/

-- 3.2 - Ver vehículos disponibles en mi torneo
-- Usa: v_vehiculos_torneo + idx_vehtorneo_torneo
DECLARE
    v_torneo_id VARCHAR2(20);
BEGIN
    SELECT id INTO v_torneo_id FROM Torneos WHERE ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('Vehículos del torneo: ' || v_torneo_id);
    
    FOR rec IN (
        SELECT marca, referencia, categoria, año
        FROM v_vehiculos_torneo
        WHERE torneo_id = v_torneo_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('  - ' || rec.marca || ' ' || rec.referencia || 
                             ' (' || rec.categoria || ', ' || rec.año || ')');
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay torneos');
END;
/

-- 3.3 - Ver circuitos usados en mi torneo
-- Usa: v_circuitos_torneo
DECLARE
    v_torneo_id VARCHAR2(20);
BEGIN
    SELECT id INTO v_torneo_id FROM Torneos WHERE ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('Circuitos del torneo: ' || v_torneo_id);
    
    FOR rec IN (
        SELECT circuito_nombre, circuito_pais, veces_usado
        FROM v_circuitos_torneo
        WHERE torneo_id = v_torneo_id
        ORDER BY veces_usado DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('  - ' || rec.circuito_nombre || ' (' || 
                             rec.circuito_pais || ') - usado ' || 
                             rec.veces_usado || ' veces');
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay torneos');
END;
/

-- 3.4 - Consultar cantidad de torneos por organizador
-- Usa: idx_torneos_organizador
DECLARE
    v_org_id VARCHAR2(10);
    v_count NUMBER;
BEGIN
    SELECT id INTO v_org_id FROM Organizadores WHERE ROWNUM = 1;
    
    SELECT COUNT(*) INTO v_count FROM Torneos WHERE organizador = v_org_id;
    
    DBMS_OUTPUT.PUT_LINE('Organizador ' || v_org_id || ' tiene ' || v_count || ' torneos');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay organizadores');
END;
/


-- 4. CONSULTAS ESTADÍSTICAS GENERALES


-- 4.2 - Estadísticas de clima
-- Usa: v_estadisticas_clima + idx_eventos_circuito
SELECT clima, total_eventos, porcentaje, torneos_diferentes
FROM v_estadisticas_clima
ORDER BY total_eventos DESC;

-- 4.3 - Torneos por plataforma
-- Usa: v_torneos_por_plataforma
SELECT plataforma_principal, total_torneos, porcentaje, organizadores_diferentes
FROM v_torneos_por_plataforma
ORDER BY total_torneos DESC;

-- 4.4 - Usuarios por país
-- Usa: v_usuarios_por_pais + idx_usuarios_pais
SELECT pais, total_usuarios, total_organizadores, porcentaje_organizadores
FROM v_usuarios_por_pais
ORDER BY total_usuarios DESC
FETCH FIRST 10 ROWS ONLY;

-- 4.5 - Actividad mensual de torneos
-- Usa: v_actividad_mensual_torneos + idx_torneos_fecha_inicio
SELECT mes, torneos_iniciados, organizadores_activos, cupo_total
FROM v_actividad_mensual_torneos
ORDER BY mes DESC
FETCH FIRST 6 ROWS ONLY;

-- 4.6 - Circuitos más utilizados
-- Usa: v_circuitos_mas_usados
SELECT circuito, pais, veces_usado, torneos_diferentes, eventos_finalizados
FROM v_circuitos_mas_usados
ORDER BY veces_usado DESC
FETCH FIRST 10 ROWS ONLY;


-- 5. CONSULTAS QUE USAN ÍNDICES

-- 5.1 - Búsqueda rápida por estado de torneo
-- Usa: idx_torneos_estado
SELECT COUNT(*) AS total, estado
FROM Torneos
GROUP BY estado
ORDER BY total DESC;

-- 5.2 - Búsqueda rápida de eventos por fecha
-- Usa: idx_eventos_fecha
SELECT COUNT(*) AS total_eventos
FROM Eventos
WHERE fecha >= TRUNC(SYSDATE)
AND fecha < TRUNC(SYSDATE) + 30;

-- 5.3 - Torneos de un juego específico en estado programado
-- Usa: idx_torneos_juego_estado 
SELECT nombre, fecha_inicio, cupo
FROM Torneos
WHERE juego = 'F1 2025'
AND estado = 'Programado'
ORDER BY fecha_inicio
FETCH FIRST 5 ROWS ONLY;

-- 5.4 - Buscar usuario por nombre
-- Usa: idx_usuarios_nombre
DECLARE
    v_usuario_id VARCHAR2(10);
BEGIN
    SELECT id INTO v_usuario_id 
    FROM Usuarios 
    WHERE nombre_usuario LIKE 'USER%' AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('Usuario encontrado: ' || v_usuario_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró usuario');
END;
/

-- 5.5 - Vehículos por categoría
-- Usa: idx_vehiculos_categoria
SELECT categoria, COUNT(*) AS total
FROM Vehiculos
GROUP BY categoria
ORDER BY total DESC;

-- 5.6 - Eventos de un torneo en estado específico
-- Usa: idx_eventos_torneo_estado (índice compuesto)
DECLARE
    v_torneo_id VARCHAR2(20);
    v_count NUMBER;
BEGIN
    SELECT id INTO v_torneo_id FROM Torneos WHERE ROWNUM = 1;
    
    SELECT COUNT(*) INTO v_count
    FROM Eventos
    WHERE torneo = v_torneo_id
    AND estado = 'Programado';
    
    DBMS_OUTPUT.PUT_LINE('Torneo ' || v_torneo_id || ' tiene ' || 
                         v_count || ' eventos programados');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay torneos');
END;
/
