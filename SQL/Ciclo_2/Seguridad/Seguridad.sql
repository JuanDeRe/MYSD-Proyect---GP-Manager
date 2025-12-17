CREATE ROLE rol_jugador;
CREATE ROLE rol_organizador;

GRANT EXECUTE ON pk_jugador TO rol_jugador;
GRANT EXECUTE ON pk_organizador TO rol_organizador;

-- La asignación de roles a los usuarios se realiza en SeguridadOK.sql