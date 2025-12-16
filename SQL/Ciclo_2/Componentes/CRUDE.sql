CREATE OR REPLACE PACKAGE PK_MANTENER_JUGADOR AS
    PROCEDURE JugadorAdicionar(
        p_nombre_usuario IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_pais IN VARCHAR2
    );
    PROCEDURE JugadorModificar(
        p_nombre_usuario IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_pais IN VARCHAR2
    );
    PROCEDURE JugadorEliminar(
        p_nombre_usuario IN VARCHAR2
    );
END PK_MANTENER_JUGADOR;
/

CREATE OR REPLACE PACKAGE PK_REGISTRAR_INSCRIPCION AS
    PROCEDURE InscripcionAdicionar(
        p_jugador IN VARCHAR2,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2,
        p_fecha IN DATE DEFAULT NULL
    );
END PK_REGISTRAR_INSCRIPCION;
/
CREATE OR REPLACE PACKAGE PK_MANTENER_INSCRIPCION AS
    PROCEDURE InscripcionModificar(
        p_jugador IN VARCHAR2,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_estado IN VARCHAR2
    );
END PK_MANTENER_INSCRIPCION;
/

CREATE OR REPLACE PACKAGE PK_REGISTRAR_RESULTADO AS
    PROCEDURE ResultadoAdicionar(
        p_jugador IN VARCHAR2,
        p_evento IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_estado_resultado IN VARCHAR2,
        p_posicion_inicio IN NUMBER,
        p_posicion_final IN NUMBER,
        p_tiempo_total IN NUMBER,
        p_mejor_vuelta IN NUMBER,
        p_puntos_obtenidos IN NUMBER
    );
END PK_REGISTRAR_RESULTADO;
/