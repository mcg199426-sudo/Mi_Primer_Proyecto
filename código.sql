USE BRASIL

#EJERCICIOS NIIVEL

-- =====================================================================
-- EJERCICIO 4 DE NIVEL 4 (CTE Avanzada con CASE WHEN y JOIN)
-- =====================================================================
-- Tablas a utilizar: detalle_pedidos, productos
-- 
-- Requerimiento del Gerente: 
-- "Necesitamos clasificar los ítems vendidos según su valor de venta. 
-- Primero, crea una CTE llamada 'detalle_con_productos' que una (JOIN) la tabla 
-- 'detalle_pedidos' con la tabla 'productos' usando el 'product_id'.
-- En esa misma CTE, utiliza un BETWEEN y un AND para filtrar los precios (price) 
-- de los ítems que se encuentren en el rango entre 20 y 400.
-- 
-- Luego, en la consulta principal, selecciona el order_id, product_id, el precio (price) 
-- y añade una columna condicional usando CASE WHEN que clasifique el precio 
-- como 'Económico' (si es menor o igual a 50) o 'Estándar' (si es mayor a 50). 
-- Finalmente, muestra los resultados ordenados del precio más alto al más bajo 
-- usando ORDER BY DESC."

WITH DETALLE_CON_PRODUCTOS AS (
    SELECT
    D.ORDER_ID,
    D.PRODUCT_ID,
    D.PRICE
    FROM DETALLE_PEDIDOS AS D   
    JOIN PRODUCTOS AS P
    ON D.PRODUCT_ID = P.PRODUCT_ID
    WHERE D.PRICE BETWEEN 20 AND 400
)
SELECT
ORDER_ID,
PRODUCT_ID,
PRICE,
CASE 
    WHEN PRICE <= 50 THEN 'ECONOMICO'
    ELSE 'ESTANDAR'
END AS CLASIFICACION
FROM DETALLE_CON_PRODUCTOS
ORDER BY PRICE DESC;


-- =====================================================================
-- EJERCICIO NIVEL 5: CTE CON CONCEPTOS COMBINADOS (NIVELES 1, 2 Y 3)
-- =====================================================================
-- REQUERIMIENTO DEL GERENTE DE VENTAS:
-- 
-- "Hola, necesito un informe financiero enfocado en ciertas categorías de productos.
-- 
-- 1. Primero, construye una CTE (tabla temporal) que consolide las ventas. 
--    Debes relacionar la información de los productos, sus traducciones al inglés, 
--    los detalles de cada pedido y los pagos realizados.
-- 
-- 2. Dentro de esa CTE, aplica los siguientes filtros:
--    - Filtra solo las ventas realizadas mediante tarjeta de crédito ('credit_card').
--    - Considera únicamente las categorías en inglés que contengan la palabra 'tech' 
--      o la palabra 'office' (usa LIKE).
--    - Selecciona solo aquellos registros cuyo precio de producto esté entre 30 y 500 (use BETWEEN).
-- 
-- 3. En la consulta principal (fuera de la CTE):
--    - Agrupa los resultados por la categoría del producto en inglés.
--    - Calcula el total de ingresos generados (SUM del precio) y la cantidad total de ítems vendidos (COUNT).
--    - Añade una columna condicional (CASE WHEN): si el total de ingresos es mayor a 5,000 
--      debe clasificarse como 'Categoría Top', de lo contrario como 'Categoría Regular'.
--    - Filtra la agrupación (HAVING) para mostrar únicamente aquellas categorías que tengan 
--      un promedio de precio por ítem (AVG) superior a 50.
--    - Ordena el resultado de mayor a menor según el total de ingresos generados.
-- =====================================================================


    WITH TABLA_TEMPORAL AS (
    SELECT
        D.ORDER_ID,
        D.PRODUCT_ID,
        D.order_item_id,
        D.PRICE,
        PA.PAYMENT_VALUE,
        PA.PAYMENT_TYPE,
        PR.product_category_name,
        TR.product_category_name_english
    FROM DETALLE_PEDIDOS AS D 
    JOIN PAGOS_PEDIDO AS PA
        ON D.ORDER_ID = PA.ORDER_ID
    JOIN PRODUCTOS AS PR   
        ON D.PRODUCT_ID = PR.PRODUCT_ID  
    JOIN TRADUCCION_CATEGORIAS AS TR
        ON PR.product_category_name = TR.product_category_name  
    WHERE PA.payment_type = 'credit_card'
      AND (TR.product_category_name_english LIKE '%tech%' OR TR.product_category_name_english LIKE '%office%')
      AND D.PRICE BETWEEN 0 AND 1000000
)
SELECT
    product_category_name_english,
    COUNT(order_item_id) AS CANTIDAD_TOTAL_PRODUCTOS_VENDIDOS,
    AVG(PRICE) AS PRECIO_VENTA_PROMEDIO,
    SUM(PAYMENT_VALUE) AS INGRESOS_GENERADOS,
    CASE
        -- El CASE evalúa el total de ingresos calculado, no un precio individual
        WHEN SUM(PAYMENT_VALUE) > 1000 THEN 'CATEGORIA TOP'
        ELSE 'CATEGORIA REGULAR'
    END AS CATEGORIAS
FROM TABLA_TEMPORAL
GROUP BY product_category_name_english
HAVING AVG(PRICE) > 500
ORDER BY SUM(PAYMENT_VALUE) DESC;

-- ==============================================================================
-- EJERCICIO 6: Auditoría de Envíos por Estado
-- ==============================================================================
-- Mensaje del Gerente de Logística:
-- "Hola, necesitamos analizar el comportamiento de las entregas y los costos de envío 
-- en nuestras principales zonas de cobertura durante el año 2017."
-- ==============================================================================

-- 1. PREPARACIÓN DE DATOS (En la CTE):
--    - Consolida la información cruzando las tablas de clientes, pedidos, 
--      detalles de cada pedido y pagos.
--    - Filtra únicamente los pedidos con estado entregado (order_status = 'delivered').
--    - Considera solo clientes en los estados: 'SP', 'RJ' o 'MG'.
--    - Limita compras entre '2017-01-01' y '2017-12-31' usando BETWEEN 
--      sobre order_purchase_timestamp.

-- 2. ANÁLISIS Y AGREGACIÓN (Consulta Principal):
--    - Agrupa por el estado del cliente (customer_state).
--    - Calcula: 
--        * Cantidad total de productos vendidos (COUNT)
--        * Suma total de flete (SUM de freight_value)
--        * Precio promedio de los productos (AVG de price)
--    - Crea una columna condicional (CASE WHEN): si el flete total acumulado 
--      es mayor a 1000, pon 'Zona de Alto Flete', sino 'Zona Estándar'.
--    - Filtra con HAVING para mostrar solo estados donde el precio promedio 
--      del producto sea mayor a 40.
--    - Ordena el resultado por el costo total de flete de mayor a menor (DESC).

-- ==============================================================================
-- ESCRIBE TU CÓDIGO ABAJO:
-- ==============================================================================

SELECT * FROM DETALLE_PEDIDOS

SELECT * FROM PEDIDOS

SELECT * FROM CLIENTES


WITH AUDITORIA_ENVIOS AS(
SELECT
DET.ORDER_ID,
DET.PRODUCT_ID,
DET.order_item_id,
DET.FREIGHT_VALUE,
DET.PRICE,
PED.ORDER_STATUS,
CLI.CUSTOMER_CITY,
CLI.CUSTOMER_STATE,
PED.order_purchase_timestamp
FROM DETALLE_PEDIDOS AS DET
JOIN PEDIDOS AS PED
ON DET.ORDER_ID = PED.order_id
JOIN CLIENTES AS CLI
ON PED.CUSTOMER_ID = CLI.CUSTOMER_ID
WHERE PED.ORDER_STATUS = 'DELIVERED'
AND CLI.CUSTOMER_STATE IN ('SP','RJ','MG')
AND PED.order_purchase_timestamp BETWEEN '2017-01-01' AND '2017-12-31'
)
SELECT
COUNT(ORDER_ITEM_ID) AS TOTAL_PRODUCTOS_VENDID,
SUM(FREIGHT_VALUE) AS TOTAL_PRECIO_ENVIO,
AVG(PRICE) AS PRECIO_PROMEDIO,
CUSTOMER_STATE,
CASE
    WHEN SUM(FREIGHT_VALUE) > 1000 THEN 'ZONA DE ALTO FLETE'
    ELSE 'ZONA ESTANDAR'
END AS ZONAS_FLETE
FROM AUDITORIA_ENVIOS
GROUP BY CUSTOMER_STATE
HAVING AVG(PRICE) > 40
ORDER BY SUM(FREIGHT_VALUE) DESC
