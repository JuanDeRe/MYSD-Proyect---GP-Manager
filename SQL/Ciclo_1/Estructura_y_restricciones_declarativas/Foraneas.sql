-- Llaves foraneas
ALTER TABLE Organizadores ADD CONSTRAINT fk_organizadores_usuarios FOREIGN KEY (id) REFERENCES Usuarios(id);
ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_organizadores FOREIGN KEY (organizador) REFERENCES Organizadores(id);
ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id);
ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre);
ALTER TABLE CircuitosDisponibles ADD CONSTRAINT fk_circuitosdisponibles_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE CircuitosDisponibles ADD CONSTRAINT fk_circuitosdisponibles_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehiculo) REFERENCES Vehiculos(marca, referencia);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehiculo) REFERENCES Vehiculos(marca, referencia);
ALTER TABLE Carreras ADD CONSTRAINT fk_carreras_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo);
ALTER TABLE Clasificaciones ADD CONSTRAINT fk_clasificaciones_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo);
ALTER TABLE Practicas ADD CONSTRAINT fk_practicas_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo);