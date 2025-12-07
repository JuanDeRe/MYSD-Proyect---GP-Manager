CREATE OR REPLACE PACKAGE PK_REGISTRAR_TORNEO AS
    PROCEDURE torneoAdicionar(
        p_nombre IN VARCHAR2,
        p_fecha_inicio IN DATE,
        p_fecha_fin IN DATE,
        p_cupo IN NUMBER,
        p_plataforma_principal IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_organizador IN VARCHAR2
    );

    PROCEDURE torneoModificar(
        p_nombre IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_cupo IN NUMBER,
        p_estado IN VARCHAR2
    );


END PK_REGISTRAR_TORNEO;
/

CREATE OR REPLACE PACKAGE PK_REGISTRAR_CARRERA AS
    PROCEDURE carreraAdicionar(
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_numero_vueltas IN NUMBER
    );

    PROCEDURE carreraModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_numero_vueltas IN NUMBER
    );


END PK_REGISTRAR_CARRERA;
/
CREATE OR REPLACE PACKAGE PK_REGISTRAR_CLASIFICACION AS
    PROCEDURE clasificacionAdicionar(
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    );

    PROCEDURE clasificacionModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    );

END PK_REGISTRAR_CLASIFICACION;
/
CREATE OR REPLACE PACKAGE PK_REGISTRAR_PRACTICA AS
    PROCEDURE practicaAdicionar(
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    );

    PROCEDURE practicaModificar(
        p_id IN NUMBER,
        p_torneo IN VARCHAR2,
        p_juego IN VARCHAR2,
        p_fecha IN DATE,
        p_clima IN VARCHAR2,
        p_hora_in_game IN VARCHAR2,
        p_circuito IN VARCHAR2,
        p_duracion IN VARCHAR2
    );


END PK_REGISTRAR_PRACTICA;
/
CREATE OR REPLACE PACKAGE PK_MANTENER_ORGANIZADOR AS
    PROCEDURE organizadorAdicionar(
        p_nombre_usuario IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_correo IN VARCHAR2
    );

    PROCEDURE organizadorModificar(
        p_nombre_usuario IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_correo IN VARCHAR2
    );

    PROCEDURE organizadorEliminar(
        p_nombre_usuario IN VARCHAR2
    );

END PK_MANTENER_ORGANIZADOR;
/
CREATE OR REPLACE PACKAGE PK_MANTENER_VEHICULO AS
    PROCEDURE vehiculoAdicionar(
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2,
        p_a_o_vehiculo IN NUMBER,
        p_categoria IN VARCHAR2,
        p_peso IN NUMBER,
        p_hp IN NUMBER
    );

    PROCEDURE vehiculoEliminar(
        p_marca_vehiculo IN VARCHAR2,
        p_referencia_vehiculo IN VARCHAR2
    );

END PK_MANTENER_VEHICULO;
/
CREATE OR REPLACE PACKAGE PK_MANTENER_CIRCUITO AS
    PROCEDURE circuitoAdicionar(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_longitud IN NUMBER
    );

    PROCEDURE circuitoEliminar(
        p_nombre IN VARCHAR2
    );

END PK_MANTENER_CIRCUITO;
/
CREATE OR REPLACE PACKAGE PK_MANTENER_JUEGO AS
    PROCEDURE juegoAdicionar(
        p_nombre IN VARCHAR2
    );

    PROCEDURE juegoEliminar(
        p_nombre IN VARCHAR2
    );

END PK_MANTENER_JUEGO;
/