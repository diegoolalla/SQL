-- =====================================================
-- GUÍA DE EJECUCIÓN - SMART DESK SQL
-- =====================================================
-- Este archivo proporciona instrucciones paso a paso para ejecutar el proyecto

/*
PASO 1: CONFIGURACIÓN INICIAL
==============================
Antes de comenzar, asegúrate de:
1. Tener acceso a un sistema de gestión de base de datos SQL
2. Tener permisos para crear bases de datos y tablas
3. Tener un cliente SQL (MySQL Workbench, pgAdmin, DBeaver, etc.)

SISTEMAS COMPATIBLES:
- MySQL 5.7+
- PostgreSQL 9.6+
- MariaDB 10.2+
- SQL Server 2016+

PASO 2: CREAR LA BASE DE DATOS
==============================
Ejecuta estos comandos para crear y usar la base de datos:
*/

CREATE DATABASE IF NOT EXISTS smart_desk_db;
USE smart_desk_db;

/*
PASO 3: CREAR EL ESQUEMA
=========================
Ejecuta el archivo: 01_schema_smart_desk.sql

Esto creará las siguientes tablas:
- Regiones
- Industrias
- Categorias
- Productos
- Clientes
- Ventas

PASO 4: CARGAR DATOS DE EJEMPLO
================================
Ejecuta el archivo: 02_datos_smart_desk.sql

Esto insertará datos de ejemplo para los años 2023-2024

PASO 5: VERIFICAR LA INSTALACIÓN
=================================
Ejecuta estas consultas para verificar que todo esté correcto:
*/

-- Verificar número de registros en cada tabla
SELECT 'Regiones' AS Tabla, COUNT(*) AS Num_Registros FROM Regiones
UNION ALL
SELECT 'Industrias', COUNT(*) FROM Industrias
UNION ALL
SELECT 'Categorias', COUNT(*) FROM Categorias
UNION ALL
SELECT 'Productos', COUNT(*) FROM Productos
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Clientes
UNION ALL
SELECT 'Ventas', COUNT(*) FROM Ventas;

-- Resultado esperado:
-- Regiones: 4
-- Industrias: 6
-- Categorias: 5
-- Productos: 13
-- Clientes: 15
-- Ventas: 48

/*
PASO 6: EJECUTAR ANÁLISIS
==========================
Una vez verificada la instalación, puedes ejecutar los archivos de análisis:

ANÁLISIS DISPONIBLES:

1. 03_analisis_ventas_beneficios_categoria.sql
   → Análisis de ventas y beneficios por categoría de productos
   → 3 consultas principales
   
2. 04_comparacion_industrias_regiones.sql
   → Comparación entre industrias en APAC y EMEA
   → 3 consultas principales
   
3. 05_clasificacion_beneficios_industria.sql
   → Clasificación de industrias por nivel de beneficio
   → 3 consultas principales
   
4. 06_comparacion_beneficios_anios.sql
   → Comparación año sobre año (2023 vs 2024)
   → 5 consultas principales
   
5. 07_calculo_acumulado_trimestre_industria.sql
   → Cálculos acumulados por trimestre e industria
   → 4 consultas principales
   
6. 08_caso_practico_libre_exploratorio.sql
   → Análisis exploratorio completo para estrategia de expansión
   → 5 pasos con múltiples consultas

CONSEJO: Ejecuta cada archivo de análisis completo y revisa los resultados.
Cada consulta está documentada con comentarios explicativos.

PASO 7: CONSULTAS RÁPIDAS DE EJEMPLO
=====================================
Aquí hay algunas consultas útiles para explorar los datos:
*/

-- Total de ventas por año
SELECT 
    YEAR(fecha_venta) AS Anio,
    COUNT(*) AS Num_Ventas,
    ROUND(SUM(cantidad * precio_venta), 2) AS Total_Ingresos
FROM Ventas
GROUP BY YEAR(fecha_venta);

-- Top 5 productos más vendidos
SELECT 
    p.producto_nombre,
    SUM(v.cantidad) AS Total_Unidades,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Total_Ingresos
FROM Ventas v
JOIN Productos p ON v.producto_id = p.producto_id
GROUP BY p.producto_id, p.producto_nombre
ORDER BY Total_Unidades DESC
LIMIT 5;

-- Ventas por región
SELECT 
    r.region_nombre,
    COUNT(DISTINCT v.venta_id) AS Num_Ventas,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Total_Ingresos
FROM Ventas v
JOIN Clientes c ON v.cliente_id = c.cliente_id
JOIN Regiones r ON c.region_id = r.region_id
GROUP BY r.region_id, r.region_nombre
ORDER BY Total_Ingresos DESC;

/*
PASO 8: LIMPIEZA (OPCIONAL)
============================
Si necesitas eliminar la base de datos y empezar de nuevo:
*/

-- ⚠️ CUIDADO: Esto eliminará toda la base de datos
-- DROP DATABASE smart_desk_db;

/*
RECURSOS ADICIONALES
====================
- README.md: Descripción general del proyecto
- DOCUMENTACION_ANALISIS.md: Explicación detallada de cada análisis
- REFLEXIONES_ESTRATEGICAS.md: Insights de negocio y recomendaciones

SOPORTE
=======
Para preguntas o problemas:
1. Revisa la documentación en los archivos .md
2. Verifica que tu sistema SQL sea compatible
3. Asegúrate de haber ejecutado los scripts en orden

¡Disfruta explorando los datos de Smart Desk!
*/
