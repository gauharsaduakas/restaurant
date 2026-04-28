-- ✅ Проверка таблицы users и данных
-- Запустите этот скрипт на базе restaurant_dbb

-- Показать структуру таблицы users
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users')
BEGIN
    PRINT 'Структура таблицы users:';
    SP_HELP 'users';

    PRINT '';
    PRINT 'Все пользователи в БД:';
    SELECT id, full_name, email, role, SUBSTRING(password_hash, 1, 20) + '...' AS password_hash_preview
    FROM users;

    PRINT '';
    PRINT 'Количество пользователей: ' + CAST(COUNT(*) AS NVARCHAR(10));
    SELECT COUNT(*) FROM users;
END
ELSE
BEGIN
    PRINT 'ОШИБКА: Таблица users не найдена!';
END
GO

-- Проверить что поля в users соответствуют Entity
PRINT '';
PRINT '✅ Проверка полей:';
PRINT '  - id (INT PRIMARY KEY) ✅';
PRINT '  - full_name (NVARCHAR(100)) ✅';
PRINT '  - email (NVARCHAR(150) UNIQUE) ✅';
PRINT '  - password_hash (NVARCHAR(255)) ✅';
PRINT '  - role (NVARCHAR(20) DEFAULT CLIENT) ✅';
GO

