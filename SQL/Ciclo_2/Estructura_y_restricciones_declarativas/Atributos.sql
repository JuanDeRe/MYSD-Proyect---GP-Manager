ALTER TABLE Jugadores ADD CONSTRAINT chk_jugadores_ranking_global CHECK (ranking_global >= 1);
ALTER TABLE Rankings ADD CONSTRAINT chk_rankings_posicion CHECK (posicion >= 1);
ALTER TABLE Rankings ADD CONSTRAINT chk_rankings_puntos_totales CHECK (puntos_totales >= 0);
ALTER TABLE Inscripciones ADD CONSTRAINT chk_inscripciones_estado CHECK (estado IN ('Pendiente', 'Aceptada', 'Rechazada'));
ALTER TABLE Resultados ADD CONSTRAINT chk_resultados_posicion_final CHECK (posicion_final >= 0);
ALTER TABLE Resultados ADD CONSTRAINT chk_resultados_posicion_inicio CHECK (posicion_inicio >= 0);
ALTER TABLE Resultados ADD CONSTRAINT chk_resultados_tiempo_total CHECK (FLOOR(tiempo_total / 10000) BETWEEN 0 AND 59 --horas entre 0 y 59
                                                                        AND FLOOR(MOD(tiempo_total, 10000) / 1000) BETWEEN 0 AND 59 -- minutos entre 0 y 59
                                                                        AND MOD(tiempo_total, 100) BETWEEN 0 AND 59); -- segundos entre 0 y 59
ALTER TABLE Resultados ADD CONSTRAINT chk_resultados_mejor_vuelta CHECK (FLOOR(mejor_vuelta / 100000) BETWEEN 0 AND 59 -- minutos entre 0 y 59
                                                                        AND FLOOR(MOD(mejor_vuelta, 100000) / 1000) BETWEEN 0 AND 59 -- segundos entre 0 y 59
                                                                        AND MOD(mejor_vuelta, 1000) BETWEEN 0 AND 999); -- milisegundos entre 0 y 999
ALTER TABLE Resultados ADD CONSTRAINT chk_resultados_puntos_obtenidos CHECK (puntos_obtenidos >= 0);
ALTER TABLE Resultados ADD CONSTRAINT chk_resultados_estado_resultado CHECK (estado_resultado IN ('Finished', 'DNF', 'DNS', 'DSQ'));