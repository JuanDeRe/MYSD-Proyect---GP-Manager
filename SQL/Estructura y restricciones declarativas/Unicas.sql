-- Llaves unicas
ALTER TABLE Usuarios ADD CONSTRAINT uk_usuarios_nombre_usuario UNIQUE (nombre_usuario);
ALTER TABLE Usuarios ADD CONSTRAINT uk_usuarios_correo UNIQUE (correo);
