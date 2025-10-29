--Tuplas
ALTER TABLE Torneos ADD CONSTRAINT chk_Torneos_Fechas CHECK (Fecha_inicio <= Fecha_fin);
--ALTER TABLE Torneos ADD CONSTRAINT chk_Torneos_estado_fechas CHECK (
--    (estado = 'Programado' AND SYSDATE < Fecha_inicio) OR
--    (estado = 'En curso' AND SYSDATE >= Fecha_inicio AND SYSDATE <= Fecha_fin) OR
--    (estado = 'Finalizado' AND SYSDATE > Fecha_fin)
--);

--ALTER TABLE Eventos ADD CONSTRAINT chk_Eventos_Fechas CHECK (
--    estado = 'Programado' AND SYSDATE < fecha OR
--    estado = 'En curso' AND SYSDATE >= fecha OR 
--    estado = 'Finalizado' AND SYSDATE > fecha
--);