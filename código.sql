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
-- EJERCICIO NIVEL 4: CTE CON CONCEPTOS COMBINADOS (NIVELES 1, 2 Y 3)
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