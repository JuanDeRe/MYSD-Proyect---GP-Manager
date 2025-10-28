-- Consultas
-- 1. Listar todos los torneos programados
SELECT * FROM Torneos WHERE estado = 'Programado';

-- 2. Listar todos los torneos organizados por un organizador específico
SELECT * FROM Torneos WHERE organizador = 'RAC0000000';

-- 3. Listar todas las carreras de un torneo específico
SELECT * FROM Carreras WHERE torneo = 'RAC00000000000000000';

-- 4. Listar todas las clasificaciones de un torneo específico
SELECT * FROM Clasificaciones WHERE torneo = 'SPE00000000000000000';

-- 5. Listar todas las prácticas de un torneo específico
SELECT * FROM Practicas WHERE torneo = 'SPE00000000000000000';

-- 6. Listar todos los eventos de un torneo específico
SELECT * FROM Eventos WHERE torneo = 'RAC00000000000000000';

-- 7. Listar todos los vehículos disponibles para un torneo específico
SELECT v.* FROM Vehiculos v
JOIN VehiculosPorTorneo vt ON v.marca = vt.marca_vehiculo AND v.referencia = vt.referencia_vehiculo
WHERE vt.torneo = 'SPE00000000000000000';

-- 8. Listar todos los circuitos disponibles para un juego específico
SELECT cd.* FROM CircuitosDisponibles cd
WHERE cd.juego = 'F1 2025';

-- 9. Listar todos los vehículos disponibles en un juego específico
SELECT v.* FROM Vehiculos v
JOIN VehiculosDeJuegos vd ON v.marca = vd.marca_vehiculo AND v.referencia = vd.referencia_vehiculo
WHERE vd.juego = 'Assetto Corsa';

-- 10. Listar los circuitos de un torneo
SELECT c.* FROM Circuitos c
JOIN Eventos e ON c.nombre = e.circuito
WHERE e.torneo = 'SPE00000000000000000';

--11. Listar la plataforma principal del torneo
SELECT t.nombre, t.plataforma_principal FROM Torneos t WHERE id = 'SPE00000000000000000';