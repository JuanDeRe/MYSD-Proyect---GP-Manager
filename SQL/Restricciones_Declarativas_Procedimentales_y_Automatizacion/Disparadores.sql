--Disparadores
-- Se crea el id del usuario y se coloca su fecha de creacion
CREATE OR REPLACE TRIGGER trg_usuarios_creacion
BEFORE INSERT ON Usuarios
FOR EACH ROW
DECLARE
    n_ultimo_usuario VARCHAR;
    parte_usuario_id VARCHAR;
BEGIN
    :NEW.fecha_registro := SYSDATE;
    parte_usuario_id := UPPER(SUBSTR(:NEW.nombre_usuario, 0, 3));
    SELECT LPAD(TO_CHAR(NVL(COUNT(id),0)),7,0) INTO n_ultimo_usuario FROM Usuarios WHERE id LIKE (parte_usuario_id || '%');
    :NEW.id := parte_usuario_id || n_ultimo_usuario;
END;
/



-- Cuando se crea un torneo se actualizan los torneos creados del organizador
CREATE OR REPLACE TRIGGER trg_torneos_actualizar_organizador
AFTER INSERT ON Torneos
FOR EACH ROW
DECLARE
    nuevo_contador NUMBER;
BEGIN
    SELECT NVL(COUNT(id),0) INTO nuevo_contador FROM Torneos
    GROUP BY id
    WHERE organizador = :NEW.organizador;
    UPDATE INTO Organizadores SET total_torneos_creados = nuevo_contador WHERE id = :NEW.organizador;
END;
/