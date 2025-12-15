#!/usr/bin/env python3
"""
Generador de Inserts Masivos para GP Manager
Simula una plataforma en funcionamiento con datos historicos y actuales
"""

import random
from datetime import datetime, timedelta

# Configuracion - Total ~100K registros
NUM_USUARIOS = 10000
NUM_ORGANIZADORES = 10000
NUM_TORNEOS = 10000
EVENTOS_POR_TORNEO_MIN = 2
EVENTOS_POR_TORNEO_MAX = 5
NUM_VEHICULOS = 150
NUM_CIRCUITOS = 80

# Datos base
JUEGOS = ['F1 2025', 'Gran Turismo 7', 'Assetto Corsa', 'Forza Motorsport', 'iRacing', 'Project CARS']
PAISES = ['Colombia', 'España', 'Mexico', 'Argentina', 'Chile', 'Brazil', 'USA', 'Italia', 'Francia', 'Alemania']
PLATAFORMAS = ['PC', 'Xbox', 'PlayStation', 'Nintendo', 'Multiplataforma']
CLIMAS = ['Despejado', 'Nublado', 'Lluvia ligera', 'Lluvia fuerte', 'Dinamico']
CATEGORIAS = ['Calle', 'Deportivo', 'Rally', 'Nascar', 'Clasico', 'Monoplaza', 'Prototipo', 'Gran Turismo', 'Otro']
MARCAS = ['Ferrari', 'Porsche', 'BMW', 'Red Bull', 'Mercedes', 'McLaren', 'Alpine', 'Aston Martin', 
          'Toyota', 'Honda', 'Ford', 'Chevrolet', 'Lamborghini', 'Audi', 'Nissan']

def generar_fecha_flexible(dias_min, dias_max):
    """Genera fecha (puede ser pasada o futura)"""
    dias = random.randint(dias_min, dias_max)
    fecha = datetime.now() + timedelta(days=dias)
    return f"TO_DATE('{fecha.strftime('%Y-%m-%d')}', 'YYYY-MM-DD')", fecha

def generar_fecha_hora_flexible(dias_min, dias_max):
    """Genera fecha con hora (puede ser pasada o futura)"""
    dias = random.randint(dias_min, dias_max)
    fecha = datetime.now() + timedelta(days=dias)
    fecha = fecha.replace(hour=random.randint(0, 23), minute=random.randint(0, 59))
    return f"TO_DATE('{fecha.strftime('%Y-%m-%d %H:%M')}', 'YYYY-MM-DD HH24:MI')", fecha

def generar_hora():
    return f"{random.randint(0, 23):02d}:{random.randint(0, 59):02d}"

def generar_duracion():
    return f"{random.randint(0, 23):02d}:{random.randint(0, 59):02d}"

def escapar_sql(texto):
    return texto.replace("'", "''")

def determinar_estado_torneo(fecha_inicio_dt, fecha_fin_dt):
    """Determina el estado del torneo según las fechas"""
    hoy = datetime.now()
    
    if fecha_fin_dt < hoy:
        return 'Finalizado' if random.random() < 0.9 else 'Cancelado'
    elif fecha_inicio_dt <= hoy <= fecha_fin_dt:
        return 'En curso'
    else:
        return 'Programado' if random.random() < 0.95 else 'Cancelado'

def determinar_estado_evento(fecha_evento_dt, estado_torneo):
    """Determina el estado del evento según su fecha y estado del torneo"""
    hoy = datetime.now()
    
    if estado_torneo == 'Cancelado':
        return 'Cancelado'
    
    if fecha_evento_dt < hoy:
        return 'Finalizado' if random.random() < 0.95 else 'Cancelado'
    elif fecha_evento_dt.date() == hoy.date():
        return 'En curso'
    else:
        return 'Programado'

def main():
    output_file = "Poblar_Masivo_Generado.sql"
    
    print("Iniciando generacion de inserts masivos...")
    print(f"Configuracion:")
    print(f"   - {NUM_USUARIOS:,} Usuarios")
    print(f"   - {NUM_ORGANIZADORES:,} Organizadores")
    print(f"   - {NUM_TORNEOS:,} Torneos")
    print(f"   - ~{NUM_TORNEOS * 3:,} Eventos estimados")
    print(f"   - {NUM_CIRCUITOS} Circuitos")
    print(f"   - {NUM_VEHICULOS} Vehiculos")
    print(f"   - Total estimado: ~100K registros\n")
    
    usuarios_ids = []
    organizadores_ids = []
    torneos_data = []
    circuitos_nombres = []
    vehiculos_data = []
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- Poblar Masivo Generado\n")
        f.write(f"-- Generado: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write("-- Simula una plataforma en funcionamiento\n")
        f.write("-- Total: ~100K registros\n")
        f.write("-- Tiempo estimado: 5-15 minutos\n\n")
        
        f.write("SET DEFINE OFF;\n")
        f.write("SET SERVEROUTPUT ON;\n")
        f.write("SET TIMING ON;\n\n")
        
        f.write("-- DESACTIVAR TRIGGERS UNO POR UNO\n")
        triggers = [
            'trg_usuarios_creacion',
            'trg_usuarios_actualizar',
            'trg_organizadores_creacion',
            'trg_torneos_creacion',
            'trg_torneos_actualizar_organizador',
            'trg_torneos_actualizar_estado',
            'trg_torneos_actualizar_estado_cancelado',
            'trg_Torneos_eliminar',
            'trg_eventos_creacion',
            'trg_eventos_actualizar_numero_torneo',
            'trg_eventos_actualizar',
            'trg_eventos_actualizar_torneo',
            'trg_Eventos_eliminar',
            'trg_carrera_exclusiva',
            'trg_clasificacion_exclusiva',
            'trg_practica_exclusiva',
            'trg_Carrera_estado_programado',
            'trg_clasificaciones_estado_programado',
            'trg_practicas_estado_programado'
        ]
        for trigger in triggers:
            f.write(f"ALTER TRIGGER {trigger} DISABLE;\n")
        f.write("\n")
        
        f.write("-- LIMPIAR TODOS LOS DATOS\n")
        f.write("DELETE FROM Practicas;\n")
        f.write("DELETE FROM Clasificaciones;\n")
        f.write("DELETE FROM Carreras;\n")
        f.write("DELETE FROM Eventos;\n")
        f.write("DELETE FROM VehiculosPorTorneo;\n")
        f.write("DELETE FROM VehiculosDeJuegos;\n")
        f.write("DELETE FROM CircuitosDisponibles;\n")
        f.write("DELETE FROM Torneos;\n")
        f.write("DELETE FROM Organizadores;\n")
        f.write("DELETE FROM Usuarios;\n")
        f.write("DELETE FROM Vehiculos;\n")
        f.write("DELETE FROM Circuitos;\n")
        f.write("DELETE FROM Juegos;\n")
        f.write("COMMIT;\n")
        f.write("PROMPT Base de datos limpiada...\n\n")
        
        f.write("-- Desactivar constraints de checks temporalmente\n")
        f.write("ALTER TABLE Torneos DISABLE CONSTRAINT chk_torneos_estado;\n")
        f.write("ALTER TABLE Eventos DISABLE CONSTRAINT chk_eventos_estado;\n")
        f.write("ALTER TABLE Torneos DISABLE CONSTRAINT chk_Torneos_Fechas;\n\n")
        
        # JUEGOS
        print("Generando Juegos...")
        f.write("-- JUEGOS BASE\n")
        for juego in JUEGOS:
            f.write(f"INSERT INTO Juegos (nombre) VALUES ('{juego}');\n")
        f.write("COMMIT;\n\n")
        
        # CIRCUITOS
        print(f"Generando {NUM_CIRCUITOS} Circuitos...")
        f.write(f"-- CIRCUITOS ({NUM_CIRCUITOS})\n")
        for i in range(1, NUM_CIRCUITOS + 1):
            nombre = f"Circuito_{i:03d}"
            circuitos_nombres.append(nombre)
            pais = random.choice(PAISES)
            longitud = round(random.uniform(3.0, 10.0), 3)
            f.write(f"INSERT INTO Circuitos (nombre, pais, longitud) VALUES ('{nombre}', '{pais}', {longitud});\n")
            if i % 100 == 0:
                f.write("COMMIT;\n")
        f.write("COMMIT;\n\n")
        
        # CIRCUITOS DISPONIBLES
        print("Generando CircuitosDisponibles...")
        f.write("-- CIRCUITOS DISPONIBLES\n")
        count = 0
        for juego in JUEGOS:
            num_circuitos_juego = random.randint(25, min(40, NUM_CIRCUITOS))
            circuitos_seleccionados = random.sample(circuitos_nombres, num_circuitos_juego)
            for circuito in circuitos_seleccionados:
                num_climas = random.randint(1, 3)
                climas_seleccionados = random.sample(CLIMAS, num_climas)
                for clima in climas_seleccionados:
                    f.write(f"INSERT INTO CircuitosDisponibles (juego, circuito, clima) ")
                    f.write(f"VALUES ('{juego}', '{circuito}', '{clima}');\n")
                    count += 1
                    if count % 200 == 0:
                        f.write("COMMIT;\n")
        f.write("COMMIT;\n\n")
        
        # VEHICULOS
        print(f"Generando {NUM_VEHICULOS} Vehiculos...")
        f.write(f"-- VEHICULOS ({NUM_VEHICULOS})\n")
        for i in range(1, NUM_VEHICULOS + 1):
            marca = random.choice(MARCAS)
            referencia = f"Modelo_{i:04d}"
            vehiculos_data.append((marca, referencia))
            año = random.randint(1990, 2025)
            categoria = random.choice(CATEGORIAS)
            if random.random() > 0.1:
                peso = round(random.uniform(800, 2000), 2)
                hp = random.randint(100, 1000)
                f.write(f"INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) ")
                f.write(f"VALUES ('{marca}', '{referencia}', {año}, '{categoria}', {peso}, {hp});\n")
            else:
                f.write(f"INSERT INTO Vehiculos (marca, referencia, año, categoria, peso, hp) ")
                f.write(f"VALUES ('{marca}', '{referencia}', {año}, '{categoria}', NULL, NULL);\n")
            if i % 100 == 0:
                f.write("COMMIT;\n")
        f.write("COMMIT;\n\n")
        
        # VEHICULOS DE JUEGOS
        print("Generando VehiculosDeJuegos...")
        f.write("-- VEHICULOS DE JUEGOS\n")
        count = 0
        for juego in JUEGOS:
            num_vehiculos_juego = random.randint(40, min(80, NUM_VEHICULOS))
            vehiculos_juego = random.sample(vehiculos_data, num_vehiculos_juego)
            for marca, referencia in vehiculos_juego:
                f.write(f"INSERT INTO VehiculosDeJuegos (juego, marca_vehiculo, referencia_vehiculo) ")
                f.write(f"VALUES ('{juego}', '{marca}', '{referencia}');\n")
                count += 1
                if count % 200 == 0:
                    f.write("COMMIT;\n")
        f.write("COMMIT;\n\n")
        
        # USUARIOS
        print(f"Generando {NUM_USUARIOS:,} Usuarios...")
        f.write(f"-- USUARIOS ({NUM_USUARIOS:,})\n")
        for i in range(1, NUM_USUARIOS + 1):
            username = f"USER{i:05d}"
            user_prefix = username[:3].upper()
            user_id = f"{user_prefix}{i-1:07d}"
            usuarios_ids.append(user_id)
            email = f"user{i:05d}@gpmail.com"
            pais = random.choice(PAISES)
            fecha_registro, _ = generar_fecha_flexible(-730, 0)
            
            f.write(f"INSERT INTO Usuarios (id, nombre_usuario, correo, pais, fecha_registro) ")
            f.write(f"VALUES ('{user_id}', '{username}', '{email}', '{pais}', {fecha_registro});\n")
            
            if i % 5000 == 0:
                f.write("COMMIT;\n")
                f.write(f"-- {i:,} usuarios insertados...\n")
        f.write("COMMIT;\n\n")
        
        # ORGANIZADORES
        print(f"Generando {NUM_ORGANIZADORES:,} Organizadores...")
        f.write(f"-- ORGANIZADORES ({NUM_ORGANIZADORES:,})\n")
        organizadores_ids = random.sample(usuarios_ids, NUM_ORGANIZADORES)
        for i, org_id in enumerate(organizadores_ids, 1):
            f.write(f"INSERT INTO Organizadores (id, total_torneos_creados) ")
            f.write(f"VALUES ('{org_id}', 0);\n")
            if i % 2000 == 0:
                f.write("COMMIT;\n")
        f.write("COMMIT;\n\n")
        
        # TORNEOS
        print(f"Generando {NUM_TORNEOS:,} Torneos...")
        f.write(f"-- TORNEOS ({NUM_TORNEOS:,})\n")
        f.write("-- Distribucion: ~60% Finalizados, ~5% En curso, ~30% Programados, ~5% Cancelados\n\n")
        
        estados_count = {'Programado': 0, 'En curso': 0, 'Finalizado': 0, 'Cancelado': 0}
        
        for i in range(1, NUM_TORNEOS + 1):
            organizador = random.choice(organizadores_ids)
            torneo_id = f"{organizador}{i:010d}"
            
            prefijos = ['GP', 'Cup', 'Championship', 'Series', 'League', 'Challenge', 'Open', 'Masters']
            sufijos = ['2023', '2024', '2025', 'Classic', 'Pro', 'Elite', 'Ultimate', 'Winter', 'Summer']
            nombre = f"{random.choice(prefijos)}_{random.choice(sufijos)}_{i:05d}"
            
            rand = random.random()
            if rand < 0.60:
                dias_inicio = random.randint(-365, -1)
            elif rand < 0.65:
                dias_inicio = random.randint(-1, 1)
            else:
                dias_inicio = random.randint(1, 730)
            
            fecha_inicio_str, fecha_inicio_dt = generar_fecha_flexible(dias_inicio, dias_inicio)
            duracion = random.randint(1, 30)
            fecha_fin_str, fecha_fin_dt = generar_fecha_flexible(dias_inicio + duracion, dias_inicio + duracion)
            
            estado = determinar_estado_torneo(fecha_inicio_dt, fecha_fin_dt)
            estados_count[estado] += 1
            
            cupo = random.randint(20, 100)
            plataforma = random.choice(PLATAFORMAS)
            juego = random.choice(JUEGOS)
            numero_eventos = 0
            
            torneos_data.append((torneo_id, juego, fecha_inicio_dt, fecha_fin_dt, estado))
            
            f.write(f"INSERT INTO Torneos (id, nombre, fecha_inicio, fecha_fin, cupo, plataforma_principal, estado, numero_eventos, organizador, juego) ")
            f.write(f"VALUES ('{torneo_id}', '{escapar_sql(nombre)}', {fecha_inicio_str}, {fecha_fin_str}, {cupo}, '{plataforma}', '{estado}', {numero_eventos}, '{organizador}', '{juego}');\n")
            
            if i % 3000 == 0:
                f.write("COMMIT;\n")
                f.write(f"-- {i:,} torneos insertados...\n")
        
        f.write("COMMIT;\n\n")
        
        print(f"Distribucion de estados:")
        print(f"   - Finalizados: {estados_count['Finalizado']:,}")
        print(f"   - En curso: {estados_count['En curso']:,}")
        print(f"   - Programados: {estados_count['Programado']:,}")
        print(f"   - Cancelados: {estados_count['Cancelado']:,}")
        
        # EVENTOS
        print("Generando Eventos...")
        f.write("-- EVENTOS\n\n")
        
        eventos_count = 0
        eventos_por_torneo = {}
        eventos_estados = {'Programado': 0, 'En curso': 0, 'Finalizado': 0, 'Cancelado': 0}
        
        for torneo_id, juego, fecha_inicio_dt, fecha_fin_dt, estado_torneo in torneos_data:
            num_eventos = random.randint(EVENTOS_POR_TORNEO_MIN, EVENTOS_POR_TORNEO_MAX)
            eventos_por_torneo[torneo_id] = num_eventos
            
            circuitos_disponibles = random.sample(circuitos_nombres, min(20, len(circuitos_nombres)))
            duracion_total = (fecha_fin_dt - fecha_inicio_dt).days
            
            for evento_num in range(num_eventos):
                evento_id = evento_num + 1
                
                if duracion_total > 0:
                    dias_offset = (duracion_total * evento_num) // num_eventos
                    fecha_evento_dt = fecha_inicio_dt + timedelta(days=dias_offset)
                    fecha_evento_dt = fecha_evento_dt.replace(
                        hour=random.randint(0, 23),
                        minute=random.randint(0, 59)
                    )
                else:
                    fecha_evento_dt = fecha_inicio_dt
                
                fecha_evento_str = f"TO_DATE('{fecha_evento_dt.strftime('%Y-%m-%d %H:%M')}', 'YYYY-MM-DD HH24:MI')"
                
                clima = random.choice(CLIMAS)
                hora_in_game = generar_hora()
                circuito = random.choice(circuitos_disponibles)
                
                estado_evento = determinar_estado_evento(fecha_evento_dt, estado_torneo)
                eventos_estados[estado_evento] += 1
                
                f.write(f"INSERT INTO Eventos (id, fecha, clima, hora_in_game, estado, torneo, circuito) ")
                f.write(f"VALUES ({evento_id}, {fecha_evento_str}, '{clima}', '{hora_in_game}', '{estado_evento}', '{torneo_id}', '{circuito}');\n")
                
                eventos_count += 1
                if eventos_count % 5000 == 0:
                    f.write("COMMIT;\n")
                    f.write(f"-- {eventos_count:,} eventos insertados...\n")
        
        f.write("COMMIT;\n\n")
        
        print(f"{eventos_count:,} eventos generados")
        print(f"Distribucion de estados:")
        print(f"   - Finalizados: {eventos_estados['Finalizado']:,}")
        print(f"   - En curso: {eventos_estados['En curso']:,}")
        print(f"   - Programados: {eventos_estados['Programado']:,}")
        print(f"   - Cancelados: {eventos_estados['Cancelado']:,}")
        
        # TIPOS DE EVENTOS
        print("Generando tipos de eventos...")
        f.write("-- TIPOS DE EVENTOS\n")
        
        carreras_count = 0
        clasificaciones_count = 0
        practicas_count = 0
        
        for torneo_id, num_eventos in eventos_por_torneo.items():
            for evento_id in range(1, num_eventos + 1):
                tipo = random.randint(0, 2)
                
                if tipo == 0:
                    vueltas = random.randint(20, 70)
                    f.write(f"INSERT INTO Carreras (id, torneo, numero_vueltas) ")
                    f.write(f"VALUES ({evento_id}, '{torneo_id}', {vueltas});\n")
                    carreras_count += 1
                elif tipo == 1:
                    duracion = generar_duracion()
                    f.write(f"INSERT INTO Clasificaciones (id, torneo, duracion) ")
                    f.write(f"VALUES ({evento_id}, '{torneo_id}', '{duracion}');\n")
                    clasificaciones_count += 1
                else:
                    duracion = generar_duracion()
                    f.write(f"INSERT INTO Practicas (id, torneo, duracion) ")
                    f.write(f"VALUES ({evento_id}, '{torneo_id}', '{duracion}');\n")
                    practicas_count += 1
                
                if (carreras_count + clasificaciones_count + practicas_count) % 5000 == 0:
                    f.write("COMMIT;\n")
        
        f.write("COMMIT;\n\n")
        
        # REACTIVAR TODO
        f.write("-- REACTIVAR CONSTRAINTS\n")
        f.write("ALTER TABLE Torneos ENABLE CONSTRAINT chk_torneos_estado;\n")
        f.write("ALTER TABLE Eventos ENABLE CONSTRAINT chk_eventos_estado;\n")
        f.write("ALTER TABLE Torneos ENABLE CONSTRAINT chk_Torneos_Fechas;\n\n")
        
        f.write("-- REACTIVAR TRIGGERS UNO POR UNO\n")
        for trigger in triggers:
            f.write(f"ALTER TRIGGER {trigger} ENABLE;\n")
        f.write("\n")
        
        # VERIFICACION
        f.write("-- VERIFICACION FINAL\n")
        f.write("SELECT 'Juegos: ' || COUNT(*) AS Resultado FROM Juegos\n")
        f.write("UNION ALL SELECT 'Circuitos: ' || COUNT(*) FROM Circuitos\n")
        f.write("UNION ALL SELECT 'Vehiculos: ' || COUNT(*) FROM Vehiculos\n")
        f.write("UNION ALL SELECT 'Usuarios: ' || COUNT(*) FROM Usuarios\n")
        f.write("UNION ALL SELECT 'Organizadores: ' || COUNT(*) FROM Organizadores\n")
        f.write("UNION ALL SELECT 'Torneos: ' || COUNT(*) FROM Torneos\n")
        f.write("UNION ALL SELECT 'Eventos: ' || COUNT(*) FROM Eventos\n")
        f.write("UNION ALL SELECT 'Carreras: ' || COUNT(*) FROM Carreras\n")
        f.write("UNION ALL SELECT 'Clasificaciones: ' || COUNT(*) FROM Clasificaciones\n")
        f.write("UNION ALL SELECT 'Practicas: ' || COUNT(*) FROM Practicas;\n\n")
        
        f.write("PROMPT ==========================================\n")
        f.write("PROMPT DISTRIBUCION DE ESTADOS - TORNEOS\n")
        f.write("PROMPT ==========================================\n")
        f.write("SELECT estado, COUNT(*) as cantidad FROM Torneos GROUP BY estado;\n\n")
        
        f.write("PROMPT ==========================================\n")
        f.write("PROMPT DISTRIBUCION DE ESTADOS - EVENTOS\n")
        f.write("PROMPT ==========================================\n")
        f.write("SELECT estado, COUNT(*) as cantidad FROM Eventos GROUP BY estado;\n\n")
        
        f.write("-- FIN\n")
    
    total_estimado = NUM_USUARIOS + NUM_ORGANIZADORES + NUM_TORNEOS + eventos_count + carreras_count + clasificaciones_count + practicas_count
    
    print(f"\nArchivo generado: {output_file}")

if __name__ == "__main__":
    main()