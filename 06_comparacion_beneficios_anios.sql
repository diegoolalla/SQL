-- =====================================================
-- ANÁLISIS 4: COMPARACIÓN DE BENEFICIOS POR AÑOS
-- =====================================================
-- Este análisis compara los beneficios entre diferentes años (2023 vs 2024)

-- Consulta principal: Comparación año sobre año
SELECT 
    YEAR(v.fecha_venta) AS Anio,
    COUNT(DISTINCT v.venta_id) AS Total_Transacciones,
    SUM(v.cantidad) AS Unidades_Vendidas,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ingresos_Totales,
    ROUND(SUM(v.costo_total), 2) AS Costos_Totales,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio_Total,
    ROUND((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
          NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100, 2) AS Margen_Beneficio_Porcentaje
FROM 
    Ventas v
GROUP BY 
    YEAR(v.fecha_venta)
ORDER BY 
    Anio;

-- Comparación con cálculo de crecimiento
WITH BeneficiosPorAnio AS (
    SELECT 
        YEAR(v.fecha_venta) AS anio,
        SUM(v.cantidad * v.precio_venta) AS ingresos,
        SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total) AS beneficio
    FROM 
        Ventas v
    GROUP BY 
        YEAR(v.fecha_venta)
)
SELECT 
    bpa.anio AS Anio,
    ROUND(bpa.ingresos, 2) AS Ingresos,
    ROUND(bpa.beneficio, 2) AS Beneficio,
    ROUND(bpa.ingresos - LAG(bpa.ingresos) OVER (ORDER BY bpa.anio), 2) AS Crecimiento_Ingresos,
    ROUND(bpa.beneficio - LAG(bpa.beneficio) OVER (ORDER BY bpa.anio), 2) AS Crecimiento_Beneficio,
    ROUND(((bpa.ingresos - LAG(bpa.ingresos) OVER (ORDER BY bpa.anio)) / 
           NULLIF(LAG(bpa.ingresos) OVER (ORDER BY bpa.anio), 0)) * 100, 2) AS Porcentaje_Crecimiento_Ingresos,
    ROUND(((bpa.beneficio - LAG(bpa.beneficio) OVER (ORDER BY bpa.anio)) / 
           NULLIF(LAG(bpa.beneficio) OVER (ORDER BY bpa.anio), 0)) * 100, 2) AS Porcentaje_Crecimiento_Beneficio
FROM 
    BeneficiosPorAnio bpa
ORDER BY 
    bpa.anio;

-- Comparación por categoría entre años
SELECT 
    c.categoria_nombre AS Categoria,
    YEAR(v.fecha_venta) AS Anio,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ingresos,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio,
    ROUND((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
          NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100, 2) AS Margen_Porcentaje
FROM 
    Ventas v
    INNER JOIN Productos p ON v.producto_id = p.producto_id
    INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
GROUP BY 
    c.categoria_id, c.categoria_nombre, YEAR(v.fecha_venta)
ORDER BY 
    c.categoria_nombre, Anio;

-- Comparación por industria entre años
SELECT 
    i.industria_nombre AS Industria,
    YEAR(v.fecha_venta) AS Anio,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ingresos,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio
FROM 
    Ventas v
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
GROUP BY 
    i.industria_id, i.industria_nombre, YEAR(v.fecha_venta)
ORDER BY 
    i.industria_nombre, Anio;

-- Análisis de tendencia mensual comparativa
SELECT 
    YEAR(v.fecha_venta) AS Anio,
    MONTH(v.fecha_venta) AS Mes,
    ROUND(SUM(v.cantidad * v.precio_venta), 2) AS Ingresos,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio
FROM 
    Ventas v
GROUP BY 
    YEAR(v.fecha_venta), MONTH(v.fecha_venta)
ORDER BY 
    Anio, Mes;
