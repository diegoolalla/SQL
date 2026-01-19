-- =====================================================
-- ANÁLISIS 5: CÁLCULO ACUMULADO POR TRIMESTRE E INDUSTRIA
-- =====================================================
-- Este análisis calcula los beneficios acumulados por trimestre e industria

-- Función auxiliar para obtener el trimestre
-- QUARTER(fecha) devuelve el trimestre (1-4)

-- Consulta principal: Beneficios por trimestre e industria
SELECT 
    i.industria_nombre AS Industria,
    YEAR(v.fecha_venta) AS Anio,
    QUARTER(v.fecha_venta) AS Trimestre,
    CONCAT('Q', QUARTER(v.fecha_venta), '-', YEAR(v.fecha_venta)) AS Periodo,
    COUNT(DISTINCT v.venta_id) AS Num_Transacciones,
    SUM(v.cantidad) AS Unidades_Vendidas,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ingresos_Totales,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio_Trimestre
FROM 
    Ventas v
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
GROUP BY 
    i.industria_id, i.industria_nombre, YEAR(v.fecha_venta), QUARTER(v.fecha_venta)
ORDER BY 
    i.industria_nombre, Anio, Trimestre;

-- Consulta con beneficio acumulado por industria
WITH BeneficiosTrimestre AS (
    SELECT 
        i.industria_nombre,
        i.industria_id,
        YEAR(v.fecha_venta) AS anio,
        QUARTER(v.fecha_venta) AS trimestre,
        ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS beneficio_trimestre
    FROM 
        Ventas v
        INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
        INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    GROUP BY 
        i.industria_id, i.industria_nombre, YEAR(v.fecha_venta), QUARTER(v.fecha_venta)
)
SELECT 
    industria_nombre AS Industria,
    anio AS Anio,
    trimestre AS Trimestre,
    CONCAT('Q', trimestre, '-', anio) AS Periodo,
    beneficio_trimestre AS Beneficio_Trimestre,
    ROUND(SUM(beneficio_trimestre) OVER (
        PARTITION BY industria_id, anio 
        ORDER BY trimestre
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS Beneficio_Acumulado_Anio,
    ROUND(SUM(beneficio_trimestre) OVER (
        PARTITION BY industria_id 
        ORDER BY anio, trimestre
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS Beneficio_Acumulado_Total
FROM 
    BeneficiosTrimestre
ORDER BY 
    industria_nombre, anio, trimestre;

-- Análisis de crecimiento trimestral con acumulado
WITH BeneficiosTrimestre AS (
    SELECT 
        i.industria_nombre,
        YEAR(v.fecha_venta) AS anio,
        QUARTER(v.fecha_venta) AS trimestre,
        SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total) AS beneficio
    FROM 
        Ventas v
        INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
        INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    GROUP BY 
        i.industria_nombre, YEAR(v.fecha_venta), QUARTER(v.fecha_venta)
)
SELECT 
    industria_nombre AS Industria,
    CONCAT('Q', trimestre, '-', anio) AS Periodo,
    ROUND(beneficio, 2) AS Beneficio_Trimestre,
    ROUND(SUM(beneficio) OVER (
        PARTITION BY industria_nombre 
        ORDER BY anio, trimestre
    ), 2) AS Beneficio_Acumulado,
    ROUND(beneficio - LAG(beneficio) OVER (
        PARTITION BY industria_nombre 
        ORDER BY anio, trimestre
    ), 2) AS Crecimiento_vs_Trimestre_Anterior,
    ROUND(((beneficio - LAG(beneficio) OVER (
        PARTITION BY industria_nombre 
        ORDER BY anio, trimestre
    )) / NULLIF(LAG(beneficio) OVER (
        PARTITION BY industria_nombre 
        ORDER BY anio, trimestre
    ), 0)) * 100, 2) AS Porcentaje_Crecimiento
FROM 
    BeneficiosTrimestre
ORDER BY 
    industria_nombre, anio, trimestre;

-- Vista consolidada: Acumulado por región, industria y trimestre
SELECT 
    r.region_nombre AS Region,
    i.industria_nombre AS Industria,
    YEAR(v.fecha_venta) AS Anio,
    QUARTER(v.fecha_venta) AS Trimestre,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio_Trimestre,
    ROUND(SUM(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) OVER (
        PARTITION BY r.region_id, i.industria_id, YEAR(v.fecha_venta) 
        ORDER BY QUARTER(v.fecha_venta)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS Beneficio_Acumulado_Anio
FROM 
    Ventas v
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    INNER JOIN Regiones r ON cl.region_id = r.region_id
GROUP BY 
    r.region_id, r.region_nombre, i.industria_id, i.industria_nombre, 
    YEAR(v.fecha_venta), QUARTER(v.fecha_venta)
ORDER BY 
    r.region_nombre, i.industria_nombre, Anio, Trimestre;
