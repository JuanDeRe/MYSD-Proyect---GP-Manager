-- Poblar Automatizado 

-- 1. DESACTIVAR TRIGGERS TEMPORALMENTE PARA LIMPIEZA
ALTER TRIGGER trg_torneos_eliminar DISABLE;
ALTER TRIGGER trg_eventos_eliminar DISABLE;

-- 2. LIMPIAR TABLAS EN ORDEN CORRECTO (RESPETANDO FKs)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Iniciando limpieza de datos...');
    
    EXECUTE IMMEDIATE 'DELETE FROM Practicas';
    DBMS_OUTPUT.PUT_LINE('Practicas eliminadas');
    
    EXECUTE IMMEDIATE 'DELETE FROM Clasificaciones';
    DBMS_OUTPUT.PUT_LINE('Clasificaciones eliminadas');
    
    EXECUTE IMMEDIATE 'DELETE FROM Carreras';
    DBMS_OUTPUT.PUT_LINE('Carreras eliminadas');
    
    EXECUTE IMMEDIATE 'DELETE FROM Eventos';
    DBMS_OUTPUT.PUT_LINE('Eventos eliminadas');
    
    EXECUTE IMMEDIATE 'DELETE FROM VehiculosPorTorneo';
    DBMS_OUTPUT.PUT_LINE('VehiculosPorTorneo eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM VehiculosDeJuegos';
    DBMS_OUTPUT.PUT_LINE('VehiculosDeJuegos eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM CircuitosDisponibles';
    DBMS_OUTPUT.PUT_LINE('CircuitosDisponibles eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM Torneos';
    DBMS_OUTPUT.PUT_LINE('Torneos eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM Organizadores';
    DBMS_OUTPUT.PUT_LINE('Organizadores eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM Usuarios';
    DBMS_OUTPUT.PUT_LINE('Usuarios eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM Vehiculos';
    DBMS_OUTPUT.PUT_LINE('Vehiculos eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM Circuitos';
    DBMS_OUTPUT.PUT_LINE('Circuitos eliminados');
    
    EXECUTE IMMEDIATE 'DELETE FROM Juegos';
    DBMS_OUTPUT.PUT_LINE('Juegos eliminados');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Todas las tablas limpiadas exitosamente');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en limpieza: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- 3. REACTIVAR TRIGGERS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_torneos_eliminar ENABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_eventos_eliminar ENABLE';
    DBMS_OUTPUT.PUT_LINE('Triggers reactivados');
END;
/

-- 4. POBLAR TABLAS BASE PRIMERO
BEGIN
    -- Insertar juegos básicos
    INSERT INTO Juegos (nombre) VALUES ('F1 2025');
    INSERT INTO Juegos (nombre) VALUES ('Gran Turismo 7');
    INSERT INTO Juegos (nombre) VALUES ('Assetto Corsa');
    INSERT INTO Juegos (nombre) VALUES ('Forza Motorsport');
    INSERT INTO Juegos (nombre) VALUES ('iRacing');
    INSERT INTO Juegos (nombre) VALUES ('Project CARS');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Juegos base insertados');

    -- Insertar circuitos básicos
    DECLARE
        TYPE paises_t IS VARRAY(10) OF VARCHAR2(20);
        paises paises_t := paises_t('Colombia', 'España', 'Mexico', 'Argentina', 'Chile', 'Brazil', 'USA', 'Italia', 'Francia', 'Alemania');
    BEGIN
        FOR i IN 1..50 LOOP
            INSERT INTO Circuitos (nombre, pais, longitud) VALUES (
                'Circuito_' || LPAD(i, 3, '0'),
                paises(MOD(i, 10) + 1),
                ROUND(DBMS_RANDOM.VALUE(3000, 8000), 2)
            );
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Circuitos base insertados');
    END;

    -- Crear relaciones CircuitosDisponibles
    DECLARE
        v_count NUMBER := 0;
    BEGIN
        FOR j IN (SELECT nombre FROM Juegos) LOOP
            FOR c IN (SELECT nombre FROM Circuitos) LOOP
                IF v_count < 200 THEN  -- Limitar a 200 relaciones para evitar sobrecarga
                    INSERT INTO CircuitosDisponibles (juego, circuito, clima) VALUES (
                        j.nombre,
                        c.nombre,
                        CASE TRUNC(DBMS_RANDOM.VALUE(0, 5))
                            WHEN 0 THEN 'Despejado' WHEN 1 THEN 'Nublado' WHEN 2 THEN 'Lluvia ligera'
                            WHEN 3 THEN 'Lluvia fuerte' ELSE 'Dinamico'
                        END
                    );
                    v_count := v_count + 1;
                END IF;
            END LOOP;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('CircuitosDisponibles insertados');
    END;
END;
/

-- 5. EJECUTAR INSERCIÓN ALEATORIA (CON TRIGGERS ACTIVOS)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Iniciando inserción de datos...');
    
    -- 25,000 USUARIOS (con países aleatorios)
    FOR i IN 1..25000 LOOP
        INSERT INTO Usuarios (nombre_usuario, correo, pais)
        VALUES (
            'USER' || LPAD(i, 5, '0'),
            'user' || LPAD(i, 5, '0') || '@gpmail.com',
            CASE TRUNC(DBMS_RANDOM.VALUE(0, 8))
                WHEN 0 THEN 'Colombia' WHEN 1 THEN 'España' WHEN 2 THEN 'Mexico'
                WHEN 3 THEN 'Argentina' WHEN 4 THEN 'Chile' WHEN 5 THEN 'Brazil'
                WHEN 6 THEN 'USA' ELSE 'Italia'
            END
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('25,000 usuarios insertados');

    -- 10,000 ORGANIZADORES (aleatorios de los usuarios)
    INSERT INTO Organizadores (id)
    SELECT u.id 
    FROM Usuarios u 
    WHERE u.nombre_usuario LIKE 'USER%'
    AND NOT EXISTS (SELECT 1 FROM Organizadores o WHERE o.id = u.id)
    ORDER BY DBMS_RANDOM.VALUE
    FETCH FIRST 10000 ROWS ONLY;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('10,000 organizadores insertados');

    -- 15,000 TORNEOS (completamente aleatorios)
    DECLARE
        TYPE plataformas_t IS VARRAY(5) OF VARCHAR2(15);
        plataformas plataformas_t := plataformas_t('PC', 'Xbox', 'PlayStation', 'Nintendo', 'Multiplataforma');
    BEGIN
        FOR i IN 1..15000 LOOP
            INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, organizador, juego)
            SELECT 
                'Torneo_' || DBMS_RANDOM.STRING('X', 10),
                SYSDATE + DBMS_RANDOM.VALUE(365, 730),
                SYSDATE + DBMS_RANDOM.VALUE(731, 1095),
                TRUNC(DBMS_RANDOM.VALUE(20, 100)),
                plataformas(TRUNC(DBMS_RANDOM.VALUE(1, 6))),
                (SELECT id FROM Organizadores ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY),
                (SELECT nombre FROM Juegos ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY)
            FROM dual;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('15,000 torneos insertados');
    END;

    -- EVENTOS
    DECLARE
        v_event_count NUMBER := 0;
    BEGIN
        FOR torneo_rec IN (
            SELECT t.id, t.fecha_inicio, t.fecha_fin, t.juego 
            FROM Torneos t 
            WHERE t.estado = 'Programado'
        ) LOOP
            FOR j IN 1..TRUNC(DBMS_RANDOM.VALUE(1, 6)) LOOP
                BEGIN
                    INSERT INTO Eventos (fecha, clima, hora_in_game, circuito, torneo)
                    SELECT
                        torneo_rec.fecha_inicio + DBMS_RANDOM.VALUE(0, torneo_rec.fecha_fin - torneo_rec.fecha_inicio),
                        (SELECT clima FROM (
                            SELECT clima FROM CircuitosDisponibles 
                            WHERE juego = torneo_rec.juego 
                            ORDER BY DBMS_RANDOM.VALUE
                        ) WHERE ROWNUM = 1),
                        LPAD(TRUNC(DBMS_RANDOM.VALUE(0, 24)), 2, '0') || ':' || LPAD(TRUNC(DBMS_RANDOM.VALUE(0, 60)), 2, '0'),
                        (SELECT circuito FROM (
                            SELECT circuito FROM CircuitosDisponibles 
                            WHERE juego = torneo_rec.juego 
                            ORDER BY DBMS_RANDOM.VALUE
                        ) WHERE ROWNUM = 1),
                        torneo_rec.id
                    FROM dual;
                    
                    v_event_count := v_event_count + 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                    WHEN OTHERS THEN
                        NULL;
                END;
            END LOOP;
        END LOOP;
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE(v_event_count || ' eventos insertados');
    END;

    -- Tipos de evento
    DECLARE
        v_tipo NUMBER;
        v_carreras NUMBER := 0;
        v_clasificaciones NUMBER := 0;
        v_practicas NUMBER := 0;
    BEGIN
        FOR event_rec IN (SELECT id, torneo FROM Eventos) LOOP
            v_tipo := TRUNC(DBMS_RANDOM.VALUE(0, 3));
            
            BEGIN
                CASE v_tipo
                    WHEN 0 THEN
                        INSERT INTO Carreras (id, torneo, numero_vueltas) 
                        VALUES (event_rec.id, event_rec.torneo, TRUNC(DBMS_RANDOM.VALUE(20, 71)));
                        v_carreras := v_carreras + 1;
                    WHEN 1 THEN
                        INSERT INTO Clasificaciones (id, torneo, duracion) 
                        VALUES (event_rec.id, event_rec.torneo, 
                               LPAD(TRUNC(DBMS_RANDOM.VALUE(0, 3)), 2, '0') || ':' || 
                               LPAD(TRUNC(DBMS_RANDOM.VALUE(0, 60)), 2, '0'));
                        v_clasificaciones := v_clasificaciones + 1;
                    WHEN 2 THEN
                        INSERT INTO Practicas (id, torneo, duracion) 
                        VALUES (event_rec.id, event_rec.torneo,
                               LPAD(TRUNC(DBMS_RANDOM.VALUE(0, 3)), 2, '0') || ':' || 
                               LPAD(TRUNC(DBMS_RANDOM.VALUE(0, 60)), 2, '0'));
                        v_practicas := v_practicas + 1;
                END CASE;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Tipos de evento asignados aleatoriamente');
        DBMS_OUTPUT.PUT_LINE('  - Carreras: ' || v_carreras);
        DBMS_OUTPUT.PUT_LINE('  - Clasificaciones: ' || v_clasificaciones);
        DBMS_OUTPUT.PUT_LINE('  - Prácticas: ' || v_practicas);
    END;

    DBMS_OUTPUT.PUT_LINE('INSERCIÓN COMPLETADA EXITOSAMENTE');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error durante inserción: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- 6. VERIFICACIÓN FINAL
PROMPT ==========================================
PROMPT VERIFICACIÓN FINAL - DATOS INSERTADOS
PROMPT ==========================================

SELECT 'Usuarios: ' || COUNT(*) FROM Usuarios
UNION ALL SELECT 'Organizadores: ' || COUNT(*) FROM Organizadores
UNION ALL SELECT 'Torneos: ' || COUNT(*) FROM Torneos
UNION ALL SELECT 'Eventos: ' || COUNT(*) FROM Eventos
UNION ALL SELECT 'Carreras: ' || COUNT(*) FROM Carreras
UNION ALL SELECT 'Clasificaciones: ' || COUNT(*) FROM Clasificaciones
UNION ALL SELECT 'Practicas: ' || COUNT(*) FROM Practicas;

PROMPT ==========================================