-- Atributos

ALTER TABLE Torneos
ADD CONSTRAINT chk_torneos_id CHECK (LENGTH(id) = 20 OR id = 'TMP')
ADD CONSTRAINT chk_torneos_plataforma CHECK (plataforma_principal IN ('PC', 'Xbox', 'PlayStation', 'Nintendo', 'Multiplataforma'))
ADD CONSTRAINT chk_torneos_cupo CHECK (cupo > 1 AND cupo <= 999)
ADD CONSTRAINT chk_torneos_estado CHECK (estado IN ('Programado', 'En curso', 'Finalizado', 'Cancelado'))
ADD CONSTRAINT chk_torneos_numero_eventos CHECK (numero_eventos >= 0);

ALTER TABLE Eventos
ADD CONSTRAINT chk_eventos_id CHECK (id >= 0 AND id <= 9999)
ADD CONSTRAINT chk_eventos_fecha CHECK (TO_CHAR(fecha, 'HH24:MI') <> '00:00')
ADD CONSTRAINT chk_eventos_clima CHECK (clima IN ('Despejado', 'Nublado', 'Lluvia ligera', 'Lluvia fuerte', 'Dinamico'))
ADD CONSTRAINT chk_eventos_hora_in_game CHECK (REGEXP_LIKE(hora_in_game, '^([01][0-9]|2[0-3]):[0-5][0-9]$') OR hora_in_game IS NULL)
ADD CONSTRAINT chk_eventos_estado CHECK (estado IN ('Programado', 'En curso', 'Finalizado', 'Cancelado'));

ALTER TABLE Carreras
ADD CONSTRAINT chk_carreras_numero_vueltas CHECK (numero_vueltas > 0 AND numero_vueltas <= 999);

ALTER TABLE Clasificaciones
ADD CONSTRAINT chk_clasificaciones_duracion CHECK (REGEXP_LIKE(duracion, '^([0-1][0-9]|2[0-3]):[0-5][0-9]$'));

ALTER TABLE Practicas
ADD CONSTRAINT chk_practicas_duracion CHECK (REGEXP_LIKE(duracion, '^([0-1][0-9]|2[0-3]):[0-5][0-9]$'));

ALTER TABLE Usuarios
ADD CONSTRAINT chk_usuarios_id CHECK (LENGTH(id) = 10 )
ADD CONSTRAINT chk_usuarios_nombre_usuario CHECK (LENGTH(nombre_usuario) >= 3 AND LENGTH(nombre_usuario) <= 15 AND NOT (nombre_usuario LIKE '% %'))
ADD CONSTRAINT chk_usuarios_correo CHECK ((correo LIKE '%_@__%.__%') OR correo IS NULL);

ALTER TABLE Organizadores
ADD CONSTRAINT chk_organizadores_total_torneos_creados CHECK (total_torneos_creados >= 0 AND total_torneos_creados <= 999999);

ALTER TABLE Circuitos
ADD CONSTRAINT chk_circuitos_longitud CHECK (longitud > 0 AND longitud <= 999999);

ALTER TABLE CircuitosDisponibles
ADD CONSTRAINT chk_circuitosdisponibles_clima CHECK (clima IN ('Despejado', 'Nublado', 'Lluvia ligera', 'Lluvia fuerte', 'Dinamico'));

ALTER TABLE Vehiculos
ADD CONSTRAINT chk_vehiculos_año CHECK (año >= 0)
ADD CONSTRAINT chk_vehiculos_categoria CHECK (categoria IN ('Calle', 'Deportivo', 'Rally', 'Nascar', 'Clasico', 'Monoplaza', 'Prototipo', 'Gran Turismo', 'Otro'))
ADD CONSTRAINT chk_vehiculos_peso CHECK ((peso > 0 AND peso <= 9999.99) OR peso IS NULL)
ADD CONSTRAINT chk_vehiculos_hp CHECK ((hp > 0 AND hp <= 9999) OR hp IS NULL);