-- usuario no existe
INSERT INTO Jugadores (id, rango) VALUES ('RAC0000010', 'Novato');

-- torneo no existe
INSERT INTO Inscripciones (jugador, torneo, marca_vehiculo, referencia_vehiculo, fecha, estado) VALUES ('RAC0000000', 'RAC00000000000000010', 'Red Bull', 'RB21', TO_DATE('2023-06-05', 'YYYY-MM-DD'), 'Aceptada');
-- estado inscripcion no valido
INSERT INTO Inscripciones (jugador, torneo, marca_vehiculo, referencia_vehiculo, fecha, estado) VALUES ('SPE0000000', 'RAC00000000000000000', 'Mercedes', 'W12', TO_DATE('2023-06-05', 'YYYY-MM-DD'), 'Confirmado');
-- tiempo mejor vuelta invalido
INSERT INTO Resultados (jugador, evento, torneo, posicion_inicio, posicion_final, mejor_vuelta, tiempo_total, puntos_obtenidos, estado_resultado) VALUES ('RAC0000000',0,'SPE00000000000000000',2,1,0170543,203421,25,'Finished');
-- tiempo total invalido
INSERT INTO Resultados (jugador, evento, torneo, posicion_inicio, posicion_final, mejor_vuelta, tiempo_total, puntos_obtenidos, estado_resultado) VALUES ('SPE0000000',0,'SPE00000000000000000',1,2,0120200,903010,0,'DNF');
-- posicion negativa
INSERT INTO Rankings (jugador,torneo,posicion,puntos_totales) VALUES ('RAC0000000', 'SPE00000000000000000',-1,25);

