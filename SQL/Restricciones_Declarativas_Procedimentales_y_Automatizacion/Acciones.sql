-- Acciones de referencia
ALTER TABLE Organizadores DROP CONSTRAINT fk_organizadores_usuarios;
ALTER TABLE Organizadores ADD CONSTRAINT fk_organizadores_usuarios FOREIGN KEY (id) REFERENCES Usuarios(id) ON DELETE CASCADE;

--ALTER TABLE Torneos DROP CONSTRAINT fk_torneos_organizadores;
--ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_organizadores FOREIGN KEY (organizador) REFERENCES Organizadores(id) ON DELETE CASCADE;

--ALTER TABLE Torneos DROP CONSTRAINT fk_torneos_juegos;
--ALTER TABLE Torneos ADD CONSTRAINT fk_torneos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre) ON DELETE CASCADE;

ALTER TABLE Eventos DROP CONSTRAINT fk_eventos_torneos;
ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id) ON DELETE CASCADE;

--ALTER TABLE Eventos DROP CONSTRAINT fk_eventos_circuitos;
--ALTER TABLE Eventos ADD CONSTRAINT fk_eventos_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre) ON DELETE CASCADE;

--ALTER TABLE CircuitosDisponibles DROP CONSTRAINT fk_circuitosdisponibles_juegos;
--ALTER TABLE CircuitosDisponibles ADD CONSTRAINT fk_circuitosdisponibles_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre) ON DELETE CASCADE;

--ALTER TABLE CircuitosDisponibles DROP CONSTRAINT fk_circuitosdisponibles_circuitos;
--ALTER TABLE CircuitosDisponibles ADD CONSTRAINT fk_circuitosdisponibles_circuitos FOREIGN KEY (circuito) REFERENCES Circuitos(nombre) ON DELETE CASCADE;

--ALTER TABLE VehiculosDeJuegos DROP CONSTRAINT fk_vehiculosdejuegos_juegos;
--ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_juegos FOREIGN KEY (juego) REFERENCES Juegos(nombre) ON DELETE CASCADE;

--ALTER TABLE VehiculosDeJuegos DROP CONSTRAINT fk_vehiculosdejuegos_vehiculos;
--ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT fk_vehiculosdejuegos_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehiculo) REFERENCES Vehiculos(marca, referencia) ON DELETE CASCADE;

--ALTER TABLE VehiculosPorTorneo DROP CONSTRAINT fk_vehiculosportorneo_torneos;
--ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_torneos FOREIGN KEY (torneo) REFERENCES Torneos(id) ON DELETE CASCADE;

--ALTER TABLE VehiculosPorTorneo DROP CONSTRAINT fk_vehiculosportorneo_vehiculos;
--ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT fk_vehiculosportorneo_vehiculos FOREIGN KEY (marca_vehiculo, referencia_vehiculo) REFERENCES Vehiculos(marca, referencia) ON DELETE CASCADE; 

--ALTER TABLE Carreras DROP CONSTRAINT fk_carreras_eventos;
--ALTER TABLE Carreras ADD CONSTRAINT fk_carreras_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo) ON DELETE CASCADE;

--ALTER TABLE Clasificaciones DROP CONSTRAINT fk_clasificaciones_eventos;
--ALTER TABLE Clasificaciones ADD CONSTRAINT fk_clasificaciones_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo) ON DELETE CASCADE;

--ALTER TABLE Practicas DROP CONSTRAINT fk_practicas_eventos;
--ALTER TABLE Practicas ADD CONSTRAINT fk_practicas_eventos FOREIGN KEY (id, torneo) REFERENCES Eventos(id, torneo) ON DELETE CASCADE;