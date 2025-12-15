-- Crear los roles para los actores del sistema
CREATE ROLE rol_organizador;
CREATE ROLE rol_desarrollador;
CREATE ROLE rol_jugador;

-- Asignar permisos a los roles
GRANT EXECUTE ON pk_organizador TO rol_organizador;
GRANT EXECUTE ON pk_desarrollador TO rol_desarrollador;
GRANT EXECUTE ON pk_jugador TO rol_jugador;

-- La asignacion de roles a los usuarios se realiza en seguridadOK.sql