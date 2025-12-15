-- TuplasOK
-- Fechas correctas
INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, plataforma_principal, cupo, estado, numero_eventos, organizador, juego)
VALUES ('SPE00000000000000001', 'Copa de Invierno', TO_DATE('2026-12-01', 'YYYY-MM-DD'), TO_DATE('2026-12-10', 'YYYY-MM-DD'), 'PC', 64, 'Programado',0, 'SPE0000000', 'F1 2025');

INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, plataforma_principal, cupo, estado, numero_eventos, organizador, juego)
VALUES ('SPE00000000000000002', 'Torneo de Otoño', TO_DATE('2024-09-05', 'YYYY-MM-DD'), TO_DATE('2024-09-15', 'YYYY-MM-DD'), 'PlayStation', 16, 'Finalizado',0, 'SPE0000000', 'Gran Turismo 7');

INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, plataforma_principal, cupo, estado, numero_eventos, organizador, juego)
VALUES ('SPE00000000000000003', 'Gran Premio de Verano', TO_DATE('2024-07-15', 'YYYY-MM-DD'), TO_DATE('2024-07-16', 'YYYY-MM-DD'), 'PC', 32, 'Finalizado',0, 'SPE0000000', 'Assetto Corsa');
