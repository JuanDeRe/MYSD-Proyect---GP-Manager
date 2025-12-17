REVOKE EXECUTE ON pk_jugador FROM rol_jugador;
REVOKE EXECUTE ON pk_organizador FROM rol_organizador;

DROP ROLE rol_jugador;
DROP ROLE rol_organizador;

DROP PACKAGE BODY pk_jugador;
DROP PACKAGE BODY pk_organizador;

DROP PACKAGE pk_jugador;
DROP PACKAGE pk_organizador;