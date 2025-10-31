-- Llaves unicas
ALTER TABLE Usuarios ADD CONSTRAINT uk_usuarios_nombre_usuario UNIQUE (nombre_usuario);
ALTER TABLE Usuarios ADD CONSTRAINT uk_usuarios_correo UNIQUE (correo);
ALTER TABLE Eventos ADD CONSTRAINT  uk_eventos_fecha_torneo UNIQUE (torneo,fecha);
