ALTER TABLE Jugadores ADD CONSTRAINT pk_jugadores PRIMARY KEY (id);
ALTER TABLE Inscripciones ADD CONSTRAINT pk_inscripciones PRIMARY KEY (jugador, torneo);
ALTER TABLE Rankings ADD CONSTRAINT pk_rankings PRIMARY KEY (jugador, torneo);
ALTER TABLE Resultados ADD CONSTRAINT pk_resultados PRIMARY KEY (jugador, torneo, evento);