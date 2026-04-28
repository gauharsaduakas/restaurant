# 🚀 Развертывание приложения Coffito Kitchen

## Быстрый старт (5 минут)

### Шаг 1: Проверьте SQL Server

```bash
# Проверьте подключение к SQL Server
# localhost:1433
# пользователь: sa
# пароль: sa

sqlcmd -S localhost -U sa -P sa
> SELECT @@VERSION;
```

### Шаг 2: Создайте БД

```sql
CREATE DATABASE restaurant_dbb;
GO
```

### Шаг 3: Компилируйте проект

```bash
cd C:\Users\Madiyar\IdeaProjects\restaurant
mvnw.cmd clean package -DskipTests
```

### Шаг 4: Развертните в Tomcat

```bash
# Скопируйте WAR
copy target\restaurant-1.0-SNAPSHOT.war C:\apache-tomcat-10.1.50\webapps\

# Переименуйте (опционально)
# ren C:\apache-tomcat-10.1.50\webapps\restaurant-1.0-SNAPSHOT.war restaurant.war
```

### Шаг 5: Запустите Tomcat

```bash
# Windows
C:\apache-tomcat-10.1.50\bin\startup.bat

# Или если Tomcat запущен как сервис
net start Tomcat10
```

### Шаг 6: Проверьте

```
http://localhost:8081/restaurant_war_exploded/
```

## Детальная инструкция

### Установка SQL Server

1. Скачайте SQL Server Express с microsoft.com
2. Установите SQL Server Management Studio (SSMS)
3. При установке SQL Server выберите:
   - Authentication mode: Mixed Mode
   - SA пароль: sa
4. Запустите SSMS и подключитесь

### Создание БД и таблиц

```sql
-- Создание БД
CREATE DATABASE restaurant_dbb;
GO

USE restaurant_dbb;
GO

-- Таблица пользователей (создается автоматически Hibernate)
-- Но вы можете создать вручную:
CREATE TABLE users (
    id BIGINT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL
);

-- Создание админа (опционально)
INSERT INTO users (full_name, email, password_hash, role)
VALUES ('Admin User', 'admin@example.com', 
        '$2a$10$bCKlrN1T9V2m5mWmEVsj2eKH1cVJPV1c5k5c5k5c5k5c5k5c5k5c5k', 'ADMIN');
```

**Примечание:** Пароль должен быть BCrypt хешированный. Используйте приложение для регистрации.

### Использование IDE (IntelliJ IDEA)

#### Способ 1: Томкат через IDE

1. Откройте Run → Edit Configurations
2. Нажмите + → Tomcat Server → Local
3. Выберите Application server: C:\apache-tomcat-10.1.50
4. На вкладке Deployment нажмите +
5. Выберите "restaurant" artifact
6. Application context: /restaurant_war_exploded
7. Нажмите Run

#### Способ 2: Spring Boot (встроенный Tomcat)

```bash
# В terminal IntelliJ IDEA
./mvnw spring-boot:run
```

### Конфигурация Tomcat

Отредактируйте `C:\apache-tomcat-10.1.50\conf\context.xml`:

```xml
<Context>
    <!-- Включите эту строку для правильной работы JSP с UTF-8 -->
    <ResourceLink name="UserDatabase" 
                  global="UserDatabase" 
                  type="org.apache.catalina.UserDatabase" />
</Context>
```

### Проверка развертывания

1. **Откройте приложение:**
   ```
   http://localhost:8081/restaurant_war_exploded/
   ```

2. **Проверьте логи Tomcat:**
   ```
   C:\apache-tomcat-10.1.50\logs\catalina.log
   ```

3. **Зарегистрируйтесь:**
   - Перейдите на /register
   - Заполните форму
   - Вы должны получить email

4. **Войдите:**
   - Используйте зарегистрированный email и пароль
   - Перейдите на /profile

## Проблемы и решения

### Ошибка: "Connection refused to host: 127.0.0.1:1433"

**Причины:**
1. SQL Server не запущен
2. Неправильные хост/порт

**Решение:**
```bash
# Проверьте статус SQL Server
sc query MSSQLSERVER

# Запустите сервис
net start MSSQLSERVER

# В SSMS проверьте порт:
# Server properties → Connections → Default port
```

### Ошибка: "Login failed for user 'sa'"

**Решение:**
```bash
# В SSMS выполните:
ALTER LOGIN sa ENABLE;
ALTER LOGIN sa WITH PASSWORD = 'sa';
```

### Ошибка: "Page not found" на /restaurant_war_exploded

**Причины:**
1. WAR не скопирован в webapps
2. Context path неправильный
3. Tomcat не развернул приложение

**Решение:**
```bash
# Проверьте наличие файла
dir C:\apache-tomcat-10.1.50\webapps\restaurant-1.0-SNAPSHOT.war

# Удалите папку развертывания и переразверните
rmdir /s C:\apache-tomcat-10.1.50\webapps\restaurant-1.0-SNAPSHOT

# Перезагрузите Tomcat
net stop Tomcat10
net start Tomcat10

# Дождитесь развертывания (1-2 минуты)
```

### Ошибка: "Email не отправляется"

**Решение:**
1. Включите "Less secure app access" в Gmail
2. Используйте App Password:
   - Перейдите на myaccount.google.com
   - Security → App passwords
   - Скопируйте пароль в application.properties

### Ошибка: Java 17 не найден

**Решение:**
```bash
# Установите Java 17
# Или установите переменную JAVA_HOME
set JAVA_HOME=C:\Program Files\Java\jdk-17

# Проверьте версию
java -version
```

## Структура папок Tomcat

```
apache-tomcat-10.1.50/
├── bin/
│   ├── startup.bat        # Запуск Tomcat
│   ├── shutdown.bat       # Остановка Tomcat
│   └── catalina.bat       # Конфигурация
├── webapps/               # Развернутые приложения
│   ├── restaurant-1.0-SNAPSHOT/   # Распакованное приложение
│   ├── restaurant-1.0-SNAPSHOT.war # WAR архив
│   ├── ROOT/
│   ├── docs/
│   ├── examples/
│   └── manager/
├── conf/
│   ├── server.xml         # Основная конфигурация
│   ├── context.xml        # Настройки контекстов
│   └── web.xml            # Настройки приложений
├── logs/
│   ├── catalina.log       # Основной лог
│   └── localhost.log      # Логи приложения
└── temp/
```

## Мониторинг приложения

### Томкат Менеджер

```
http://localhost:8080/manager/html
```

Стандартные учетные данные обычно:
- Username: tomcat
- Password: tomcat

Если не работает, отредактируйте `conf/tomcat-users.xml`.

### Логи приложения

Основной лог:
```
C:\apache-tomcat-10.1.50\logs\catalina.log
```

Фильтруйте по времени запуска приложения.

### Проверка здоровья приложения

```bash
# Проверьте, что приложение работает
curl http://localhost:8081/restaurant_war_exploded/login

# Должны получить HTML страницу логина
```

## Обновление приложения

1. Остановите Tomcat:
   ```bash
   net stop Tomcat10
   ```

2. Удалите старую версию:
   ```bash
   rmdir /s C:\apache-tomcat-10.1.50\webapps\restaurant-1.0-SNAPSHOT
   del C:\apache-tomcat-10.1.50\webapps\restaurant-1.0-SNAPSHOT.war
   ```

3. Скомпилируйте новую версию:
   ```bash
   mvnw.cmd clean package -DskipTests
   ```

4. Скопируйте новый WAR:
   ```bash
   copy target\restaurant-1.0-SNAPSHOT.war C:\apache-tomcat-10.1.50\webapps\
   ```

5. Запустите Tomcat:
   ```bash
   net start Tomcat10
   ```

## Резервная копия БД

```sql
-- Создание backup'a
BACKUP DATABASE restaurant_dbb
TO DISK = 'C:\Backup\restaurant_dbb_backup.bak'
WITH INIT, COMPRESSION;

-- Восстановление из backup'a
RESTORE DATABASE restaurant_dbb
FROM DISK = 'C:\Backup\restaurant_dbb_backup.bak'
WITH REPLACE;
```

## Чек-лист перед запуском

- [ ] Java 17 установлена
- [ ] SQL Server запущен
- [ ] БД `restaurant_dbb` создана
- [ ] Tomcat установлен и запущен
- [ ] Port 8081 свободен
- [ ] JAVA_HOME правильно установлена
- [ ] application.properties настроена
- [ ] Email конфигурация работает
- [ ] WAR скопирован в webapps
- [ ] Приложение доступно по URL

## Контакты и поддержка

При проблемах:
1. Проверьте логи: `C:\apache-tomcat-10.1.50\logs\catalina.log`
2. Проверьте консоль IDE при развертывании из IDE
3. Убедитесь, что SQL Server доступен
4. Перезагрузитесь Tomcat

