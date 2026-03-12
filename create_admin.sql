USE restaurant_dbb;
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

DELETE FROM users WHERE email = 'admin@gauhar.kz';
GO


INSERT INTO users (full_name, email, password_hash, role)
VALUES (
    N'Admin',
    N'admin@gauhar.kz',
    N'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a',
    N'ADMIN'
);
GO

SELECT id, full_name, email, role FROM users;
GO

PRINT 'Admin created! Login: admin@gauhar.kz / Password: admin123';
GO

