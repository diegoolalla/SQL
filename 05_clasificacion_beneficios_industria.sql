-- =====================================================
-- ANÁLISIS 3: CLASIFICACIÓN DE BENEFICIOS POR INDUSTRIA (ALTO O NORMAL)
-- =====================================================
-- Este análisis clasifica las industrias según su nivel de beneficio

-- Cálculo del beneficio promedio general para establecer el umbral
-- Esta consulta se usa como referencia para la clasificación

-- Consulta principal: Clasificación de beneficios por industria
WITH BeneficiosPorIndustria AS (
    SELECT 
        i.industria_nombre,
        SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total) AS beneficio_total,
        COUNT(DISTINCT v.venta_id) AS num_transacciones,
        ROUND((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / COUNT(DISTINCT v.venta_id), 2) AS beneficio_promedio_transaccion
    FROM 
        Ventas v
        INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
        INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    GROUP BY 
        i.industria_id, i.industria_nombre
),
PromedioGeneral AS (
    SELECT AVG(beneficio_promedio_transaccion) AS umbral_promedio
    FROM BeneficiosPorIndustria
)
SELECT 
    bpi.industria_nombre AS Industria,
    ROUND(bpi.beneficio_total, 2) AS Beneficio_Total,
    bpi.num_transacciones AS Num_Transacciones,
    bpi.beneficio_promedio_transaccion AS Beneficio_Promedio_Transaccion,
    ROUND(pg.umbral_promedio, 2) AS Umbral_General,
    CASE 
        WHEN bpi.beneficio_promedio_transaccion > pg.umbral_promedio THEN 'ALTO'
        ELSE 'NORMAL'
    END AS Clasificacion_Beneficio
FROM 
    BeneficiosPorIndustria bpi
    CROSS JOIN PromedioGeneral pg
ORDER BY 
    bpi.beneficio_promedio_transaccion DESC;

-- Clasificación alternativa basada en percentiles (Top 33% = Alto, Medio 33% = Normal, Bajo 33% = Bajo)
WITH BeneficiosPorIndustria AS (
    SELECT 
        i.industria_nombre,
        SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total) AS beneficio_total,
        ROUND((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
              NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100, 2) AS margen_beneficio
    FROM 
        Ventas v
        INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
        INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    GROUP BY 
        i.industria_id, i.industria_nombre
)
SELECT 
    industria_nombre AS Industria,
    beneficio_total AS Beneficio_Total,
    margen_beneficio AS Margen_Beneficio_Porcentaje,
    CASE 
        WHEN margen_beneficio >= 40 THEN 'ALTO'
        WHEN margen_beneficio >= 30 THEN 'NORMAL'
        ELSE 'BAJO'
    END AS Clasificacion_Margen
FROM 
    BeneficiosPorIndustria
ORDER BY 
    margen_beneficio DESC;

-- Análisis detallado por región con clasificación
SELECT 
    i.industria_nombre AS Industria,
    r.region_nombre AS Region,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio_Total,
    ROUND((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
          NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100, 2) AS Margen_Beneficio,
    CASE 
        WHEN (SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
             NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100 >= 40 THEN 'ALTO'
        WHEN (SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
             NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100 >= 30 THEN 'NORMAL'
        ELSE 'BAJO'
    END AS Clasificacion
FROM 
    Ventas v
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    INNER JOIN Regiones r ON cl.region_id = r.region_id
GROUP BY 
    i.industria_id, i.industria_nombre, r.region_id, r.region_nombre
ORDER BY 
    i.industria_nombre, Margen_Beneficio DESC;
