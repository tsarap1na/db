-- =============================================
-- БАЗОВЫЕ ОПЕРАЦИИ SELECT
-- =============================================

-- 1. Получить всех активных пользователей
SELECT user_id, username, email, first_name, last_name, role_id
FROM "User"
WHERE is_active = TRUE;

-- 2. Найти пользователя по email
SELECT * FROM "User" WHERE email = 'client1@mail.ru';

-- 3. Получить все доступные растения с ценами
SELECT plant_id, name, price, stock_quantity 
FROM Plant 
WHERE is_available = TRUE AND stock_quantity > 0;

-- 4. Получить растения определенной категории
SELECT p.name, p.price, c.name as category_name
FROM Plant p
JOIN Category c ON p.category_id = c.category_id
WHERE c.name = 'Комнатные растения';

-- 5. Получить заказы пользователя с деталями
SELECT o.order_id, o.order_date, o.total_amount, o.status, 
       u.first_name, u.last_name
FROM "Order" o
JOIN "User" u ON o.user_id = u.user_id
WHERE u.user_id = 3;

-- =============================================
-- ОПЕРАЦИИ ВСТАВКИ (INSERT)
-- =============================================

-- 6. Добавить нового пользователя
INSERT INTO "User" (username, email, password_hash, first_name, last_name, role_id)
VALUES ('newclient', 'newclient@mail.ru', 'hashed_password_new', 'Иван', 'Новиков', 3);

-- 7. Добавить новое растение
INSERT INTO Plant (name, scientific_name, description, price, stock_quantity, 
                  category_id, supplier_id, care_level, is_available)
VALUES ('Спатифиллум', 'Spathiphyllum', 'Растение с белыми цветами', 1500.00, 10, 1, 1, 'Легкий', TRUE);

-- 8. Добавить товар в корзину
INSERT INTO CartItem (cart_id, plant_id, quantity)
VALUES (1, 3, 1);

-- =============================================
-- ОПЕРАЦИИ ОБНОВЛЕНИЯ (UPDATE)
-- =============================================

-- 9. Обновить цену растения
UPDATE Plant SET price = 2700.00 WHERE plant_id = 1;

-- 10. Обновить статус заказа
UPDATE "Order" SET status = 'Выполнен' WHERE order_id = 2;

-- 11. Обновить количество товара на складе после покупки
UPDATE Plant SET stock_quantity = stock_quantity - 1 WHERE plant_id = 1;

-- =============================================
-- ОПЕРАЦИИ УДАЛЕНИЯ (DELETE)
-- =============================================

-- 12. Удалить элемент из корзины
DELETE FROM CartItem WHERE cart_item_id = 1;

-- 13. Деактивировать пользователя
UPDATE "User" SET is_active = FALSE WHERE user_id = 5;

-- =============================================
-- СЛОЖНЫЕ ЗАПРОСЫ
-- =============================================

-- 14. Получить топ-5 самых дорогих растений
SELECT name, price, scientific_name
FROM Plant
WHERE is_available = TRUE
ORDER BY price DESC
LIMIT 5;

-- 15. Получить общую сумму продаж по месяцам
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    COUNT(*) as order_count,
    SUM(total_amount) as total_sales
FROM "Order"
WHERE status = 'Выполнен'
GROUP BY year, month
ORDER BY year, month;

-- 16. Получить растения с низким запасом (меньше 10)
SELECT name, stock_quantity, s.company_name as supplier
FROM Plant p
JOIN Supplier s ON p.supplier_id = s.supplier_id
WHERE stock_quantity < 10 AND is_available = TRUE;

-- 17. Получить корзину пользователя с общей стоимостью
SELECT u.username, p.name, ci.quantity, p.price, 
       (ci.quantity * p.price) as total_price
FROM CartItem ci
JOIN Cart c ON ci.cart_id = c.cart_id
JOIN "User" u ON c.user_id = u.user_id
JOIN Plant p ON ci.plant_id = p.plant_id
WHERE u.user_id = 3;

-- 18. Получить детали заказа с товарами (ИСПРАВЛЕНО - используем представление для subtotal)
SELECT o.order_id, o.order_date, o.status,
       p.name as product_name, oi.quantity, oi.unit_price, 
       (oi.quantity * oi.unit_price) as subtotal
FROM "Order" o
JOIN OrderItem oi ON o.order_id = oi.order_id
JOIN Plant p ON oi.plant_id = p.plant_id
WHERE o.order_id = 1;

-- 19. Найти самых активных пользователей (по количеству заказов)
SELECT u.first_name, u.last_name, u.email,
       COUNT(o.order_id) as order_count,
       SUM(o.total_amount) as total_spent
FROM "User" u
LEFT JOIN "Order" o ON u.user_id = o.user_id
WHERE u.role_id = 3
GROUP BY u.user_id, u.first_name, u.last_name, u.email
ORDER BY order_count DESC, total_spent DESC;

-- 20. Получить растения с руководствами по уходу
SELECT p.name, cg.title as guide_title, cg.content
FROM Plant p
JOIN PlantCare pc ON p.plant_id = pc.plant_id
JOIN CareGuide cg ON pc.guide_id = cg.guide_id
ORDER BY p.name, pc.priority;

-- =============================================
-- АГРЕГАТНЫЕ ЗАПРОСЫ
-- =============================================

-- 21. Общее количество товаров на складе
SELECT SUM(stock_quantity) as total_stock FROM Plant WHERE is_available = TRUE;

-- 22. Средняя цена по категориям
SELECT c.name as category, 
       AVG(p.price) as average_price,
       COUNT(p.plant_id) as product_count
FROM Category c
LEFT JOIN Plant p ON c.category_id = p.category_id AND p.is_available = TRUE
GROUP BY c.category_id, c.name
ORDER BY average_price DESC;

-- 23. Поставщики с количеством товаров
SELECT s.company_name, 
       COUNT(p.plant_id) as product_count,
       SUM(p.stock_quantity) as total_stock
FROM Supplier s
LEFT JOIN Plant p ON s.supplier_id = p.supplier_id AND p.is_available = TRUE
GROUP BY s.supplier_id, s.company_name
ORDER BY product_count DESC;

-- =============================================
-- ЗАПРОСЫ С ФИЛЬТРАЦИЕЙ И СОРТИРОВКОЙ
-- =============================================

-- 24. Растения в ценовом диапазоне
SELECT name, price, care_level, light_requirements
FROM Plant
WHERE price BETWEEN 1000 AND 3000
AND is_available = TRUE
ORDER BY price ASC;

-- 25. Поиск растений по названию
SELECT name, scientific_name, price, stock_quantity
FROM Plant
WHERE name ILIKE '%фикус%' OR scientific_name ILIKE '%ficus%'
AND is_available = TRUE;

-- 26. Заказы за последние 30 дней
SELECT order_id, order_date, total_amount, status
FROM "Order"
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY order_date DESC;

-- =============================================
-- ТРАНЗАКЦИОННЫЕ ОПЕРАЦИИ
-- =============================================

-- 27. Оформление заказа из корзины (пример транзакции) - ИСПРАВЛЕНО
BEGIN;

-- Создание заказа
INSERT INTO "Order" (user_id, total_amount, status, delivery_address_id, shipping_cost)
VALUES (3, 4100.00, 'Ожидает оплаты', 1, 300.00)
RETURNING order_id;

-- Перенос товаров из корзины в заказ (ИСПРАВЛЕНО - без subtotal)
INSERT INTO OrderItem (order_id, plant_id, quantity, unit_price)
SELECT 4, ci.plant_id, ci.quantity, p.price
FROM CartItem ci
JOIN Plant p ON ci.plant_id = p.plant_id
WHERE ci.cart_id = 1;

-- Обновление запасов
UPDATE Plant p
SET stock_quantity = stock_quantity - ci.quantity
FROM CartItem ci
WHERE p.plant_id = ci.plant_id AND ci.cart_id = 1;

-- Очистка корзины
DELETE FROM CartItem WHERE cart_id = 1;

COMMIT;
