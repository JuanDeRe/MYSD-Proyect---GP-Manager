-- ÍNDICES PARA BÚSQUEDAS POR ESTADO
-- Torneos por estado (consultas de manager y organizador)
CREATE INDEX idx_torneos_estado ON Torneos(estado);

-- Eventos por estado (consultas frecuentes de organizador)
CREATE INDEX idx_eventos_estado ON Eventos(estado);


-- ÍNDICES PARA RELACIONES FRECUENTES
-- Torneos por organizador (consultas de organizador específico)
CREATE INDEX idx_torneos_organizador ON Torneos(organizador);

-- Torneos por juego (consultas de jugador: torneos de un juego específico)
CREATE INDEX idx_torneos_juego ON Torneos(juego);

-- Eventos por torneo (navegación torneo -> eventos)
CREATE INDEX idx_eventos_torneo ON Eventos(torneo);

-- Eventos por circuito (estadísticas por circuito)
CREATE INDEX idx_eventos_circuito ON Eventos(circuito);



-- ÍNDICES PARA BÚSQUEDAS TEMPORALES
-- Torneos por fecha de inicio (consultas temporales)
CREATE INDEX idx_torneos_fecha_inicio ON Torneos(fecha_inicio);

-- Eventos por fecha (consultas de calendario)
CREATE INDEX idx_eventos_fecha ON Eventos(fecha);


-- ÍNDICES COMPUESTOS PARA CONSULTAS COMPLEJAS
-- Torneos por organizador y estado (consultas gerenciales)
CREATE INDEX idx_torneos_org_estado ON Torneos(organizador, estado);

-- Torneos por juego y estado (consultas de jugador)
CREATE INDEX idx_torneos_juego_estado ON Torneos(juego, estado);

-- Eventos por torneo y estado (validaciones de triggers)
CREATE INDEX idx_eventos_torneo_estado ON Eventos(torneo, estado);

-- Eventos por torneo y fecha (validaciones temporales)
CREATE INDEX idx_eventos_torneo_fecha ON Eventos(torneo, fecha);


-- ÍNDICES PARA TABLAS DE RELACIÓN
-- CircuitosDisponibles por juego (consultas de jugador)
CREATE INDEX idx_circdisp_juego ON CircuitosDisponibles(juego);

-- CircuitosDisponibles por circuito
CREATE INDEX idx_circdisp_circuito ON CircuitosDisponibles(circuito);

-- VehiculosDeJuegos por juego (consultas de jugador)
CREATE INDEX idx_vehjuego_juego ON VehiculosDeJuegos(juego);

-- VehiculosPorTorneo por torneo (consultas de organizador)
CREATE INDEX idx_vehtorneo_torneo ON VehiculosPorTorneo(torneo);


-- ÍNDICES PARA BÚSQUEDAS POR USUARIO
-- Usuarios por nombre de usuario (login, búsquedas)
CREATE INDEX idx_usuarios_nombre ON Usuarios(nombre_usuario);

-- Usuarios por país (estadísticas geográficas)
CREATE INDEX idx_usuarios_pais ON Usuarios(pais);


-- ÍNDICES PARA VEHÍCULOS Y CIRCUITOS
-- Vehículos por categoría (filtros de jugador)
CREATE INDEX idx_vehiculos_categoria ON Vehiculos(categoria);

-- Vehículos por año (filtros históricos)
CREATE INDEX idx_vehiculos_año ON Vehiculos(año);

-- Circuitos por país (estadísticas geográficas)
CREATE INDEX idx_circuitos_pais ON Circuitos(pais);


-- ÍNDICES PARA TIPOS DE EVENTOS
-- Carreras por torneo (consultas específicas)
CREATE INDEX idx_carreras_torneo ON Carreras(torneo);

-- Clasificaciones por torneo
CREATE INDEX idx_clasificaciones_torneo ON Clasificaciones(torneo);

-- Prácticas por torneo
CREATE INDEX idx_practicas_torneo ON Practicas(torneo);