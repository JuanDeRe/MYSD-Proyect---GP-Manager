-- ÍNDICES PARA BÚSQUEDAS POR ESTADO
-- Torneos por estado (consultas de manager y organizador)
CREATE INDEX idx_torneos_estado ON Torneos(estado);

-- Eventos por estado (consultas frecuentes de organizador)
CREATE INDEX idx_eventos_estado ON Eventos(estado);


-- ÍNDICES PARA RELACIONES FRECUENTES
-- Torneos por organizador (consultas de organizador específico)
CREATE INDEX idx_torneos_organizador ON Torneos(organizador);


-- Eventos por circuito (estadísticas por circuito)
CREATE INDEX idx_eventos_circuito ON Eventos(circuito);



-- ÍNDICES PARA VEHÍCULOS Y CIRCUITOS
-- Vehículos por categoría (filtros de jugador)
CREATE INDEX idx_vehiculos_categoria ON Vehiculos(categoria);


-- ÍNDICES PARA TIPOS DE EVENTOS
-- Carreras por torneo (consultas específicas)
CREATE INDEX idx_carreras_torneo ON Carreras(torneo);

-- Clasificaciones por torneo
CREATE INDEX idx_clasificaciones_torneo ON Clasificaciones(torneo);

-- Prácticas por torneo
CREATE INDEX idx_practicas_torneo ON Practicas(torneo);