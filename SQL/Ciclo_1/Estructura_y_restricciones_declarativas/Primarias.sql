-- Llaves primarias
ALTER TABLE Torneos ADD CONSTRAINT pk_torneos PRIMARY KEY (id);
ALTER TABLE Eventos ADD CONSTRAINT pk_eventos PRIMARY KEY (id, torneo); 
ALTER TABLE Carreras ADD CONSTRAINT pk_carreras PRIMARY KEY (id, torneo);
ALTER TABLE Clasificaciones ADD CONSTRAINT pk_clasificaciones PRIMARY KEY (id, torneo);
ALTER TABLE Practicas ADD CONSTRAINT pk_practicas PRIMARY KEY (id, torneo);
ALTER TABLE Juegos ADD CONSTRAINT pk_juegos PRIMARY KEY (nombre);
ALTER TABLE Circuitos ADD CONSTRAINT pk_circuitos PRIMARY KEY (nombre);
ALTER TABLE Vehiculos ADD CONSTRAINT pk_vehiculos PRIMARY KEY (marca, referencia);
ALTER TABLE Organizadores ADD CONSTRAINT pk_organizadores PRIMARY KEY (id);
ALTER TABLE Usuarios ADD CONSTRAINT pk_usuarios PRIMARY KEY (id);
ALTER TABLE CircuitosDisponibles ADD CONSTRAINT pk_circuitosdisponibles PRIMARY KEY (juego, circuito, clima);
ALTER TABLE VehiculosDeJuegos ADD CONSTRAINT pk_vehiculosdejuegos PRIMARY KEY (juego, marca_vehiculo, referencia_vehiculo);
ALTER TABLE VehiculosPorTorneo ADD CONSTRAINT pk_vehiculosportorneo PRIMARY KEY (torneo, marca_vehiculo, referencia_vehiculo);
