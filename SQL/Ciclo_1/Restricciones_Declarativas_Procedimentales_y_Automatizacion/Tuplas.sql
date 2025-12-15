--Tuplas
ALTER TABLE Torneos ADD CONSTRAINT chk_Torneos_Fechas CHECK (Fecha_inicio <= Fecha_fin);
