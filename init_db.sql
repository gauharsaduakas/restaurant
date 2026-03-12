USE restaurant_dbb;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'menu_items')
CREATE TABLE menu_items (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    name       NVARCHAR(100)  NOT NULL,
    category   NVARCHAR(50)   NOT NULL,
    price      DECIMAL(10,2)  NOT NULL,
    image_url  NVARCHAR(255)  NULL DEFAULT '',
    available  BIT            NOT NULL DEFAULT 1
);
GO

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
    price        DECIMAL(10,2) NOT NULL
);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
CREATE TABLE users (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    full_name     NVARCHAR(100) NOT NULL,
    email         NVARCHAR(150) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    role          NVARCHAR(20)  NOT NULL DEFAULT 'CLIENT'
);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'restaurant')
CREATE TABLE restaurant (
    id          INT PRIMARY KEY,
    name        NVARCHAR(100) NOT NULL,
    address     NVARCHAR(200) NULL DEFAULT '',
    phone       NVARCHAR(50)  NULL DEFAULT '',
    work_hours  NVARCHAR(100) NULL DEFAULT '',
    description NVARCHAR(500) NULL DEFAULT ''
);
GO

INSERT INTO menu_items (name, category, price, image_url, available) VALUES
    (N'Burger',  N'Main',    2500, '/assets/img/burger.jpg', 1),
    (N'Pizza',   N'Main',    3500, '/assets/img/pizza.jpg',  1),
    (N'Coffee',  N'Drink',   1200, '/assets/img/coffee.jpg', 1),
    (N'Dessert', N'Dessert', 900,  '',                       1);
GO

PRINT 'Database initialized successfully!';
GO

