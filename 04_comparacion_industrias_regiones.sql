-- =====================================================
-- ANÁLISIS 2: COMPARACIÓN ENTRE INDUSTRIAS POR REGIÓN (APAC, EMEA)
-- =====================================================
-- Este análisis compara el rendimiento de diferentes industrias en las regiones APAC y EMEA

-- Consulta principal: Comparación de industrias en APAC y EMEA
SELECT 
    i.industria_nombre AS Industria,
    r.region_nombre AS Region,
    COUNT(DISTINCT v.venta_id) AS Total_Ventas,
    SUM(v.cantidad) AS Unidades_Vendidas,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ingresos_Totales,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio_Total,
    ROUND(AVG(v.cantidad * v.precio_venta), 2) AS Ticket_Promedio
FROM 
    Ventas v
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    INNER JOIN Regiones r ON cl.region_id = r.region_id
WHERE 
    r.region_nombre IN ('APAC', 'EMEA')
GROUP BY 
    i.industria_id, i.industria_nombre, r.region_id, r.region_nombre
ORDER BY 
    i.industria_nombre, r.region_nombre;

-- Consulta pivote: Comparación directa APAC vs EMEA
SELECT 
    i.industria_nombre AS Industria,
    ROUND(SUM(CASE WHEN r.region_nombre = 'APAC' THEN v.cantidad * v.precio_venta ELSE 0 END), 2) AS Ingresos_APAC,
    ROUND(SUM(CASE WHEN r.region_nombre = 'EMEA' THEN v.cantidad * v.precio_venta ELSE 0 END), 2) AS Ingresos_EMEA,
    ROUND(SUM(CASE WHEN r.region_nombre = 'APAC' THEN v.cantidad * v.precio_venta - v.costo_total ELSE 0 END), 2) AS Beneficio_APAC,
    ROUND(SUM(CASE WHEN r.region_nombre = 'EMEA' THEN v.cantidad * v.precio_venta - v.costo_total ELSE 0 END), 2) AS Beneficio_EMEA,
    ROUND(SUM(CASE WHEN r.region_nombre = 'APAC' THEN v.cantidad * v.precio_venta ELSE 0 END) - 
          SUM(CASE WHEN r.region_nombre = 'EMEA' THEN v.cantidad * v.precio_venta ELSE 0 END), 2) AS Diferencia_Ingresos,
    ROUND(SUM(CASE WHEN r.region_nombre = 'APAC' THEN v.cantidad * v.precio_venta - v.costo_total ELSE 0 END) - 
          SUM(CASE WHEN r.region_nombre = 'EMEA' THEN v.cantidad * v.precio_venta - v.costo_total ELSE 0 END), 2) AS Diferencia_Beneficio
FROM 
    Ventas v
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    INNER JOIN Regiones r ON cl.region_id = r.region_id
WHERE 
    r.region_nombre IN ('APAC', 'EMEA')
GROUP BY 
    i.industria_id, i.industria_nombre
ORDER BY 
    Diferencia_Beneficio DESC;

-- Análisis de cuota de mercado por industria en cada región
WITH TotalesRegion AS (
    SELECT 
        r.region_nombre,
        SUM(v.cantidad * v.precio_venta) AS total_region
    FROM 
        Ventas v
        INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
        INNER JOIN Regiones r ON cl.region_id = r.region_id
    WHERE 
        r.region_nombre IN ('APAC', 'EMEA')
    GROUP BY 
        r.region_nombre
)
SELECT 
    i.industria_nombre AS Industria,
    r.region_nombre AS Region,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ingresos,
    ROUND((SUM(v.cantidad * v.precio_venta) / tr.total_region) * 100, 2) AS Porcentaje_Cuota_Mercado
FROM 
    Ventas v
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    INNER JOIN Regiones r ON cl.region_id = r.region_id
    INNER JOIN TotalesRegion tr ON r.region_nombre = tr.region_nombre
WHERE 
    r.region_nombre IN ('APAC', 'EMEA')
GROUP BY 
    i.industria_id, i.industria_nombre, r.region_id, r.region_nombre, tr.total_region
ORDER BY 
    r.region_nombre, Porcentaje_Cuota_Mercado DESC;
