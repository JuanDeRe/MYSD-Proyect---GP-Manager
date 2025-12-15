INSERT INTO Jugadores (id, ranking_global) VALUES ('RAC0000000', 1);
INSERT INTO Jugadores (id, ranking_global) VALUES ('SPE0000000', 2);

INSERT INTO Inscripciones (jugador, torneo, marca_vehiculo, referencia_vehiculo, fecha, estado) VALUES ('RAC0000000', 'RAC00000000000000000', 'Red Bull', 'RB21', TO_DATE('2023-06-05', 'YYYY-MM-DD'), 'Aceptada');
INSERT INTO Inscripciones (jugador, torneo, marca_vehiculo, referencia_vehiculo, fecha, estado) VALUES ('SPE0000000', 'RAC00000000000000000', 'Mercedes', 'W12', TO_DATE('2023-06-05', 'YYYY-MM-DD'), 'Aceptada');

INSERT INTO Resultados (jugador, evento, torneo, posicion_inicio, posicion_final, mejor_vuelta, tiempo_total, puntos_obtenidos, estado_resultado) VALUES ('RAC0000000',0,'RAC00000000000000000',2,1,0116543,153421,25,'Finished');
INSERT INTO Resultados (jugador, evento, torneo, posicion_inicio, posicion_final, mejor_vuelta, tiempo_total, puntos_obtenidos, estado_resultado) VALUES ('SPE0000000',0,'RAC00000000000000000',1,2,0120200,103010,0,'DNF');

INSERT INTO Rankings (jugador,torneo,posicion,puntos_totales) VALUES ('RAC0000000', 'RAC00000000000000000',1,25);
INSERT INTO Rankings (jugador,torneo,posicion,puntos_totales) VALUES ('SPE0000000', 'RAC00000000000000000',2,0);

