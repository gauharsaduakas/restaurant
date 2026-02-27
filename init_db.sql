-- =========================================================
--  Gauhar Restaurant — SQL Server DDL
--  База: restaurant_dbb
--  Выполнить один раз перед запуском приложения
-- =========================================================

USE restaurant_dbb;
GO

-- 1. Таблица блюд меню
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'menu_items')
CREATE TABLE menu_items (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    name       NVARCHAR(100)  NOT NULL,
    category   NVARCHAR(50)   NOT NULL,
    price      INT            NOT NULL,
    image_url  NVARCHAR(255)  NULL DEFAULT '',
    available  BIT            NOT NULL DEFAULT 1
);
GO

-- 2. Таблица заказов
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'orders')
CREATE TABLE orders (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    customer_name NVARCHAR(100)  NOT NULL,
    phone         NVARCHAR(30)   NULL DEFAULT '',
    status        NVARCHAR(30)   NOT NULL DEFAULT 'PENDING',
    created_at    DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- 3. Позиции заказов
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'order_items')
CREATE TABLE order_items (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    order_id     INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id INT NOT NULL REFERENCES menu_items(id),
    qty          INT NOT NULL DEFAULT 1,
    price        INT NOT NULL
);
GO

-- =========================================================
--  Тестовые данные (запустить по желанию)
-- =========================================================

-- Блюда
INSERT INTO menu_items (name, category, price, image_url, available) VALUES
    (N'Burger',  N'Main',    2500, '/assets/img/burger.jpg', 1),
    (N'Pizza',   N'Main',    3500, '/assets/img/pizza.jpg',  1),
    (N'Coffee',  N'Drink',   1200, '/assets/img/coffee.jpg', 1),
    (N'Dessert', N'Dessert', 900,  '',                       1);
GO

PRINT 'Database initialized successfully!';
GO

