-- Para búsquedas por rango de jugador
CREATE INDEX idx_jugadores_rango ON Jugadores(rango);

-- Para consultar inscripciones por estado (pendientes)
CREATE INDEX idx_inscripciones_estado ON Inscripciones(estado);

-- Para consultar inscripciones de un torneo
CREATE INDEX idx_inscripciones_torneo ON Inscripciones(torneo);

-- Para consultar rankings de un jugador
CREATE INDEX idx_rankings_jugador ON Rankings(jugador);

-- Para ordenar rankings por puntos
CREATE INDEX idx_rankings_puntos ON Rankings(torneo, puntos_totales DESC);

-- Para consultar resultados por evento
CREATE INDEX idx_resultados_evento ON Resultados(torneo, evento);

-- Para estadísticas por estado de resultado
CREATE INDEX idx_resultados_estado ON Resultados(estado_resultado);

-- Índice compuesto para consultas de jugador en torneos
CREATE INDEX idx_resultados_jugador_torneo ON Resultados(jugador, torneo);