-- Примеры данных для тестирования системы корзины

-- Добавить тестовые товары (если их нет)
INSERT INTO menu_items (name, category, price, available, image_url) VALUES
('Маргарита', 'Pizza', 1500.00, 1, '/static/images/margherita.jpg'),
('Пепперони', 'Pizza', 1800.00, 1, '/static/images/pepperoni.jpg'),
('Классический', 'Burger', 1200.00, 1, '/static/images/classic-burger.jpg'),
('Чизбургер', 'Burger', 1400.00, 1, '/static/images/cheeseburger.jpg'),
('Кола', 'Drink', 300.00, 1, '/static/images/cola.jpg'),
('Лимонад', 'Drink', 350.00, 1, '/static/images/lemonade.jpg');

-- Пример заказа с несколькими товарами
-- (Заказ создается через приложение при оформлении)

-- Проверить доступные товары:
SELECT id, name, category, price, available FROM menu_items WHERE available = 1;

-- Проверить историю заказов:
SELECT o.id, o.customer_name, o.phone, o.status, o.created_at, o.toppings,
       SUM(oi.qty) as item_count, SUM(oi.qty * oi.price) as total
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.customer_name, o.phone, o.status, o.created_at, o.toppings
ORDER BY o.created_at DESC;

-- Проверить детали конкретного заказа:
SELECT o.id, o.customer_name, o.phone, o.status, o.toppings,
       m.name as item_name, m.category, oi.qty, oi.price, (oi.qty * oi.price) as line_total
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.id
LEFT JOIN menu_items m ON m.id = oi.menu_item_id
WHERE o.id = ?
ORDER BY oi.id;

-- Удалить тестовые заказы (если нужно):
DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE customer_name = 'Test User');
DELETE FROM orders WHERE customer_name = 'Test User';

