USE BRASIL

-- ==============================================================================
-- EJERCICIO 1: Auditoría de Transacciones de Alto Valor (Tabla: PAGOS_PEDIDO)
-- ==============================================================================
-- Mensaje del Director Financiero:
-- "Para el reporte de liquidez, necesito analizar las operaciones individuales más 
-- elevadas pagadas mediante tarjeta de crédito o boleto bancario. Considera únicamente 
-- aquellas transacciones cuyo importe cobrado se encuentre en el rango de 200 a 1000. 
-- Muestra solo los 10 cobros más altos, asignando nombres claros a las columnas 
-- para presentarlo directamente en la junta."

-- ESCRIBE TU CÓDIGO ABAJO:

SELECT
TOP 10 *
FROM PAGOS_PEDIDO
WHERE PAYMENT_VALUE BETWEEN 200 AND 1000
AND (PAYMENT_TYPE IN ('CREDIT_CARD', 'BOLETO'))
ORDER BY PAYMENT_VALUE DESC

-- ==============================================================================
-- EJERCICIO 2: Depuración del Catálogo de Tecnología (Tabla: PRODUCTOS)
-- ==============================================================================
-- Mensaje del Director Financiero:
-- "Estamos revisando la rentabilidad de las líneas de negocio tecnológicas. Requiero 
-- una lista sin duplicados de las categorías de productos que contengan los términos 
-- 'eletronicos', 'electromesticos', 'informatica', 'telefonia', consoles_games en su nombre. Asegúrate de excluir del informe cualquier 
-- registro que carezca de un nombre de categoría asignado."

-- ESCRIBE TU CÓDIGO ABAJO:

SELECT
DISTINCT product_category_name
FROM PRODUCTOS
WHERE product_category_name LIKE '%eletronicos%' 
OR product_category_name LIKE '%electromesticos%'
OR product_category_name LIKE '%informatica%'
OR product_category_name LIKE '%telefonia%'
OR product_category_name LIKE '%consoles_games%'


-- ==============================================================================
-- EJERCICIO 3: Mapeo de Clientes en Región Sur (Tabla: CLIENTES)
-- ==============================================================================
-- Mensaje del Director Financiero:
-- "Queremos evaluar la concentración de cartera en el sur. Necesito la lista de 
-- clientes cuyo registro corresponda exclusivamente a las ciudades de Curitiba, 
-- Porto Alegre o Florianópolis. Presenta el resultado ordenado alfabéticamente, 
-- primero por el estado y posteriormente por la ciudad."

-- ESCRIBE TU CÓDIGO ABAJO:

SELECT *
FROM CLIENTES
WHERE CUSTOMER_CITY IN ('CURITIBA', 'PORTO ALEGRE', 'FLORIANOPOLIS')
ORDER BY CUSTOMER_STATE, CUSTOMER_CITY ASC



-- ==============================================================================
-- EJERCICIO 4 (REVISADO): Control de Riesgo y Cancelaciones (Tabla: PEDIDOS)
-- ==============================================================================
-- Mensaje del Director Financiero:
-- "En el departamento de riesgos estamos auditando pérdidas por pedidos no completados. 
-- Extrae las órdenes cuyo estado sea cancelado o que no contengan registrada una 
-- fecha de entrega al cliente, habiendo sido realizadas durante el periodo del 
-- 1 de octubre de 2017 al 31 de diciembre de 2017. Para facilitarle la lectura a la 
-- junta, clasifica el tipo de incidencia en una columna asignándole el texto 
-- 'Cancelado' cuando el estado del pedido sea cancelado, y 'Pendiente de Entrega' 
-- en cualquier otro caso. Ordena la lista comenzando por las compras más recientes."

-- ESCRIBE TU CÓDIGO ABAJO:

SELECT
order_id,
customer_id,
order_status,
order_purchase_timestamp,
order_delivered_carrier_date,
CASE 
    WHEN order_status = 'canceled' then 'Cancelado'
    ELSE 'PENDIENTE DE ENTREGA'
END AS 'CLASIFICACIÓN'
FROM PEDIDOS
WHERE (ORDER_STATUS = 'canceled' 
OR order_delivered_customer_date IS NULL)
AND order_purchase_timestamp between '20171001' AND '20171231'
ORDER BY order_purchase_timestamp DESC

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_carrier_date,
    CASE 
        WHEN order_status = 'canceled' THEN 'Cancelado'
        ELSE 'PENDIENTE DE ENTREGA'
    END AS CLASIFICACION
FROM PEDIDOS
WHERE (order_status = 'canceled' OR order_delivered_customer_date IS NULL)
  AND order_purchase_timestamp BETWEEN '20171001' AND '20171231'
ORDER BY order_purchase_timestamp DESC;

-- ==============================================================================
-- EJERCICIO 5 (REVISADO): Alerta de Fletes Desproporcionados (Tabla: DETALLE_PEDIDOS)
-- ==============================================================================
-- Mensaje del Director Financiero:
-- "Margen operativo nos alerta sobre envíos cuyo flete erosiona el margen del producto. 
-- Busca los artículos donde el costo de envío supere los 50 y cuyo precio de venta 
-- sea menor o igual a 30. Incluye una columna de severidad para el comité: si el flete 
-- es superior a 80, clasifícalo como 'Alerta Crítica', de lo contrario nómbralo 
-- 'Alerta Moderada'. Deseo visualizar únicamente los 15 casos donde el flete haya 
-- alcanzado los valores más altos."

-- ESCRIBE TU CÓDIGO ABAJO: