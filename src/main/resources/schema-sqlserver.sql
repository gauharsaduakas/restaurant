-- ========== SQL SERVER SCHEMA ==========

IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
IF OBJECT_ID('orders', 'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('menu_items', 'U') IS NOT NULL DROP TABLE menu_items;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
IF OBJECT_ID('restaurant', 'U') IS NOT NULL DROP TABLE restaurant;

CREATE TABLE users (
                       id BIGINT IDENTITY(1,1) PRIMARY KEY,
                       full_name VARCHAR(255),
                       email VARCHAR(255) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       role VARCHAR(50) DEFAULT 'USER'
);

CREATE TABLE restaurant (
                            id INT IDENTITY(1,1) PRIMARY KEY,
                            name VARCHAR(100) NOT NULL,
                            address VARCHAR(200),
                            phone VARCHAR(50),
                            work_hours VARCHAR(100),
                            description VARCHAR(500)
);

CREATE TABLE menu_items (
                            id INT IDENTITY(1,1) PRIMARY KEY,
                            name VARCHAR(255) NOT NULL,
                            category VARCHAR(255),
                            price FLOAT NOT NULL,
                            available BIT DEFAULT 1,
                            image_url VARCHAR(500)
);

CREATE TABLE orders (
                        id INT IDENTITY(1,1) PRIMARY KEY,
                        customer_name VARCHAR(255),
                        phone VARCHAR(50),
                        status VARCHAR(50) DEFAULT 'PENDING',
                        created_at DATETIME DEFAULT GETDATE(),
                        user_id BIGINT,
                        customer_email VARCHAR(255),
                        toppings VARCHAR(1000),
                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE order_items (
                             id INT IDENTITY(1,1) PRIMARY KEY,
                             order_id INT NOT NULL,
                             menu_item_id INT NOT NULL,
                             qty INT DEFAULT 1,
                             price FLOAT,
                             options VARCHAR(500),
                             options_price FLOAT DEFAULT 0,
                             FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
                             FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE
);

-- Вставка тестовых данных
INSERT INTO menu_items (name, category, price, image_url, available)
VALUES
    ('Burger', 'Main', 2500, '/assets/img/burger.jpg', 1),
    ('Pizza', 'Main', 3500, '/assets/img/pizza.jpg', 1),
    ('Coffee', 'Drink', 1200, '/assets/img/coffee.jpg', 1),
    ('Dessert', 'Dessert', 900, '/assets/img/ponshik.jpg', 1);
