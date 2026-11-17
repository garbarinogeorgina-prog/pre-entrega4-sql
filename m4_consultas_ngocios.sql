SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

WITH FacturacionPorProducto AS (
    SELECT 
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
),
PromedioGeneral AS (
    SELECT AVG(total_facturado) AS promedio_facturacion
    FROM FacturacionPorProducto
)
SELECT 
    f.id_producto,
    f.total_facturado,
    CASE 
        WHEN f.total_facturado >= p.promedio_facturacion THEN 'Por encima'
        ELSE 'Por debajo'
    END AS clasificacion_promedio
FROM FacturacionPorProducto f
CROSS JOIN PromedioGeneral p;

-- =============================================================================
-- 5. HALLAZGOS DE NEGOCIO
-- =============================================================================
-- Hallazgo 1 (Estacionalidad/Ventas): 
-- El volumen de facturación y transacciones se concentra en el mes analizado, 
-- presentando un ticket promedio consistente con compras corporativas o de equipamiento tecnológico.
-- Hallazgo 2 (Concentración de ingresos): 
-- La facturación por producto muestra una marcada dispersión: los artículos de telefonía/computación 
-- se ubican 'Por encima' del promedio de facturación, impulsando la mayor parte del ingreso total del negocio.
-- Hallazgo 3 (Fidelización y recurrencia): 
-- En este período no se registran clientes recurrentes (todos realizaron una única compra), 
-- lo que indica una oportunidad clave para implementar estrategias de retención o cross-selling.