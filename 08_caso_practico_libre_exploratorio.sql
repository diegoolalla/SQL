-- =====================================================
-- ANÁLISIS 6: CASO PRÁCTICO LIBRE - ANÁLISIS EXPLORATORIO
-- =====================================================
-- Pregunta de negocio: ¿Qué productos y categorías deberíamos priorizar 
-- en nuestra estrategia de expansión por región para maximizar beneficios?

-- =====================================================
-- PASO 1: Análisis de Rendimiento de Productos por Región
-- =====================================================

-- Identificar los productos top por región
WITH ProductosRegion AS (
    SELECT 
        r.region_nombre,
        p.producto_nombre,
        c.categoria_nombre,
        SUM(v.cantidad) AS unidades_vendidas,
        ROUND(SUM(v.cantidad * v.precio_venta), 2) AS ingresos_totales,
        ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS beneficio_total,
        ROUND((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
              NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100, 2) AS margen_beneficio,
        ROW_NUMBER() OVER (PARTITION BY r.region_id ORDER BY 
            SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total) DESC) AS ranking_beneficio
    FROM 
        Ventas v
        INNER JOIN Productos p ON v.producto_id = p.producto_id
        INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
        INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
        INNER JOIN Regiones r ON cl.region_id = r.region_id
    GROUP BY 
        r.region_id, r.region_nombre, p.producto_id, p.producto_nombre, c.categoria_nombre
)
SELECT 
    region_nombre AS Region,
    producto_nombre AS Producto,
    categoria_nombre AS Categoria,
    unidades_vendidas AS Unidades_Vendidas,
    ingresos_totales AS Ingresos,
    beneficio_total AS Beneficio,
    margen_beneficio AS Margen_Porcentaje,
    ranking_beneficio AS Ranking
FROM 
    ProductosRegion
WHERE 
    ranking_beneficio <= 3
ORDER BY 
    region_nombre, ranking_beneficio;

-- =====================================================
-- PASO 2: Análisis de Penetración de Mercado
-- =====================================================

-- Análisis de cuántas industrias compran cada categoría por región
SELECT 
    r.region_nombre AS Region,
    c.categoria_nombre AS Categoria,
    COUNT(DISTINCT i.industria_id) AS Num_Industrias_Compradoras,
    COUNT(DISTINCT v.cliente_id) AS Num_Clientes_Unicos,
    ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS Beneficio_Total,
    ROUND(AVG(v.cantidad * v.precio_venta), 2) AS Ticket_Promedio
FROM 
    Ventas v
    INNER JOIN Productos p ON v.producto_id = p.producto_id
    INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
    INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
    INNER JOIN Industrias i ON cl.industria_id = i.industria_id
    INNER JOIN Regiones r ON cl.region_id = r.region_id
GROUP BY 
    r.region_id, r.region_nombre, c.categoria_id, c.categoria_nombre
ORDER BY 
    r.region_nombre, Beneficio_Total DESC;

-- =====================================================
-- PASO 3: Análisis de Oportunidades de Cross-Selling
-- =====================================================

-- Identificar combinaciones de categorías compradas por los mismos clientes
WITH ComprasCliente AS (
    SELECT DISTINCT
        v.cliente_id,
        c.categoria_nombre
    FROM 
        Ventas v
        INNER JOIN Productos p ON v.producto_id = p.producto_id
        INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
)
SELECT 
    cc1.categoria_nombre AS Categoria_1,
    cc2.categoria_nombre AS Categoria_2,
    COUNT(DISTINCT cc1.cliente_id) AS Clientes_Compraron_Ambas,
    ROUND(COUNT(DISTINCT cc1.cliente_id) * 100.0 / 
          (SELECT COUNT(DISTINCT cliente_id) FROM ComprasCliente), 2) AS Porcentaje_Clientes
FROM 
    ComprasCliente cc1
    INNER JOIN ComprasCliente cc2 ON cc1.cliente_id = cc2.cliente_id
WHERE 
    cc1.categoria_nombre < cc2.categoria_nombre
GROUP BY 
    cc1.categoria_nombre, cc2.categoria_nombre
HAVING 
    COUNT(DISTINCT cc1.cliente_id) >= 2
ORDER BY 
    Clientes_Compraron_Ambas DESC;

-- =====================================================
-- PASO 4: Análisis de Tendencias de Crecimiento
-- =====================================================

-- Identificar categorías con mayor crecimiento
WITH VentasPorPeriodo AS (
    SELECT 
        c.categoria_nombre,
        YEAR(v.fecha_venta) AS anio,
        ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS beneficio
    FROM 
        Ventas v
        INNER JOIN Productos p ON v.producto_id = p.producto_id
        INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
    GROUP BY 
        c.categoria_nombre, YEAR(v.fecha_venta)
)
SELECT 
    categoria_nombre AS Categoria,
    MAX(CASE WHEN anio = 2023 THEN beneficio END) AS Beneficio_2023,
    MAX(CASE WHEN anio = 2024 THEN beneficio END) AS Beneficio_2024,
    ROUND(MAX(CASE WHEN anio = 2024 THEN beneficio END) - 
          MAX(CASE WHEN anio = 2023 THEN beneficio END), 2) AS Crecimiento_Absoluto,
    ROUND(((MAX(CASE WHEN anio = 2024 THEN beneficio END) - 
            MAX(CASE WHEN anio = 2023 THEN beneficio END)) / 
           NULLIF(MAX(CASE WHEN anio = 2023 THEN beneficio END), 0)) * 100, 2) AS Crecimiento_Porcentual
FROM 
    VentasPorPeriodo
GROUP BY 
    categoria_nombre
ORDER BY 
    Crecimiento_Porcentual DESC;

-- =====================================================
-- PASO 5: Score de Priorización para Estrategia de Expansión
-- =====================================================

-- Combinar múltiples factores para crear un score de priorización
WITH MetricasPorRegionCategoria AS (
    SELECT 
        r.region_nombre,
        c.categoria_nombre,
        ROUND(SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total), 2) AS beneficio,
        ROUND((SUM(v.cantidad * v.precio_venta) - SUM(v.costo_total)) / 
              NULLIF(SUM(v.cantidad * v.precio_venta), 0) * 100, 2) AS margen,
        COUNT(DISTINCT v.cliente_id) AS num_clientes,
        SUM(v.cantidad) AS volumen_unidades
    FROM 
        Ventas v
        INNER JOIN Productos p ON v.producto_id = p.producto_id
        INNER JOIN Categorias c ON p.categoria_id = c.categoria_id
        INNER JOIN Clientes cl ON v.cliente_id = cl.cliente_id
        INNER JOIN Regiones r ON cl.region_id = r.region_id
    GROUP BY 
        r.region_nombre, c.categoria_nombre
)
SELECT 
    region_nombre AS Region,
    categoria_nombre AS Categoria,
    beneficio AS Beneficio_Total,
    margen AS Margen_Porcentaje,
    num_clientes AS Num_Clientes,
    volumen_unidades AS Volumen_Unidades,
    -- Score ponderado: 40% beneficio + 30% margen + 20% clientes + 10% volumen
    ROUND(
        (beneficio / (SELECT MAX(beneficio) FROM MetricasPorRegionCategoria) * 40) +
        (margen / (SELECT MAX(margen) FROM MetricasPorRegionCategoria) * 30) +
        (num_clientes / (SELECT MAX(num_clientes) FROM MetricasPorRegionCategoria) * 20) +
        (volumen_unidades / (SELECT MAX(volumen_unidades) FROM MetricasPorRegionCategoria) * 10),
        2
    ) AS Score_Priorizacion
FROM 
    MetricasPorRegionCategoria
ORDER BY 
    Score_Priorizacion DESC;
