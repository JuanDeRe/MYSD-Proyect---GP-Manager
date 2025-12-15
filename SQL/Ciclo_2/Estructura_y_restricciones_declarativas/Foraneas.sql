ALTER TABLE Jugadores ADD CONSTRAINT fk_jugadores_usuario FOREIGN KEY (id) REFERENCES Usuarios(id);
ALTER TABLE Inscripciones ADD CONSTRAINT fk_inscripciones_jugador FOREIGN KEY (jugador) REFERENCES Jugadores(id);
ALTER TABLE Inscripciones ADD CONSTRAINT fk_inscripciones_torneo FOREIGN KEY (torneo) REFERENCES Torneos(id);
ALTER TABLE Inscripciones ADD CONSTRAINT fk_inscripciones_vehiculo FOREIGN KEY (marca_vehiculo, referencia_vehiculo) REFERENCES Vehiculos(marca, referencia);
ALTER TABLE Resultados ADD CONSTRAINT fk_resultados_jugador FOREIGN KEY (jugador) REFERENCES Jugadores (id);
ALTER TABLE Resultados ADD CONSTRAINT fk_resultados_evento FOREIGN KEY (torneo, evento) REFERENCES Eventos (torneo,id);
ALTER TABLE Rankings ADD CONSTRAINT fk_rankings_jugador FOREIGN KEY (jugador) REFERENCES Jugadores(id);
ALTER TABLE Rankings ADD CONSTRAINT fk_rankings_torneo FOREIGN KEY (torneo) REFERENCES Torneos(id);