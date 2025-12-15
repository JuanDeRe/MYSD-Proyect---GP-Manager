ALTER TABLE Resultados ADD CONSTRAINT chk_resultados_estado_puntos CHECK (estado_resultado = 'Finished' OR puntos_obtenidos = 0);
