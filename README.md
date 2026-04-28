# 🍷 Coffito Kitchen - Полнофункциональное веб-приложение ресторана

Полнофункциональная система управления рестораном на Spring Boot с поддержкой:
- ✅ Аутентификация и авторизация (Spring Security)
- ✅ Управление пользователями и ролями (USER, ADMIN)
- ✅ Личный кабинет с изменением пароля
- ✅ Админ панель для управления пользователями
- ✅ Email уведомления
- ✅ CRUD функционал
- ✅ REST API для управления пользователями

## Требования

- Java 17+
- Maven 3.6+
- SQL Server 2019+ (локально на localhost:1433)
- База данных: `restaurant_dbb`
- Пользователь SQL Server: `sa` / пароль: `sa`

## Структура проекта

```
src/main/java/com/gauhar/restaurant/
├── controller/          # REST и веб контроллеры
│   ├── AuthController.java
│   ├── ProfileController.java
│   ├── AdminDashboardController.java
│   └── RestUserController.java
├── service/            # Бизнес логика
│   ├── UserService.java
│   ├── EmailService.java
│   └── OrderService.java
├── entity/             # JPA сущности
│   └── User.java
├── repository/         # Spring Data JPA репозитории
│   └── UserRepository.java
├── security/           # Spring Security конфигурация
│   ├── SecurityConfig.java
│   └── CustomUserDetailsService.java
└── dto/               # DTO для API
    ├── RegisterRequest.java
    └── UserResponse.java

src/main/webapp/WEB-INF/views/
├── login.jsp           # Страница входа
├── register.jsp        # Страница регистрации
├── profile.jsp         # Личный кабинет
├── change-password.jsp # Смена пароля
└── admin/             # Админ панель
    ├── dashboard.jsp
    ├── users.jsp
    ├── menu-items.jsp
    ├── orders.jsp
    └── statistics.jsp
```

## Установка и запуск

### 1. Подготовка базы данных

Запустите SQL Server и создайте БД:

```sql
CREATE DATABASE restaurant_dbb;
GO
USE restaurant_dbb;
GO
```

Затем Hibernate автоматически создаст таблицы при первом запуске (ddl-auto=update).

### 2. Компиляция и сборка

```bash
# Очистка и компиляция
./mvnw clean compile

# Сборка WAR
./mvnw package
```

### 3. Развертывание в Tomcat

```bash
# Скопируйте WAR в папку webapps
cp target/restaurant-1.0-SNAPSHOT.war C:\apache-tomcat-10.1.50\webapps\

# Или используйте IDE развертывание
```

### 4. Запуск приложения

Приложение доступно по адресу:
```
http://localhost:8081/restaurant_war_exploded/
```

## Функционал по ролям

### 👤 Обычный пользователь (USER)
- Регистрация и вход в систему
- Просмотр профиля
- Изменение пароля
- Просмотр меню и оформление заказов
- Просмотр истории заказов

### 👑 Администратор (ADMIN)
- Все права USER
- Админ панель: `/admin`
- Управление пользователями: `/admin/users`
- Просмотр и изменение ролей пользователей
- Удаление пользователей
- Управление меню
- Управление заказами
- Просмотр статистики

## Роуты приложения

### Публичные
- `GET /` - Главная страница
- `GET /login` - Страница входа
- `GET /register` - Страница регистрации
- `POST /register` - Обработка регистрации

### Для авторизованных пользователей
- `GET /home` - Главная страница приложения
- `GET /profile` - Мой профиль
- `POST /profile/update` - Обновление профиля
- `GET /profile/change-password` - Смена пароля
- `POST /profile/change-password` - Обработка смены пароля
- `GET /logout` - Выход

### Только для ADMIN
- `GET /admin` - Админ панель
- `GET /admin/users` - Список пользователей
- `GET /admin/users/{id}` - Деталь пользователя
- `POST /admin/users/{id}/grant-admin` - Выдать права администратора
- `POST /admin/users/{id}/revoke-admin` - Забрать права администратора
- `POST /admin/users/{id}/delete` - Удалить пользователя

## REST API

### Управление пользователями (только ADMIN)

```bash
# Получить всех пользователей
GET /api/users

# Получить пользователя
GET /api/users/{id}

# Удалить пользователя
DELETE /api/users/{id}

# Выдать права администратора
POST /api/users/{id}/grant-admin

# Забрать права администратора
POST /api/users/{id}/revoke-admin
```

## Конфигурация

Основные параметры в `application.properties`:

```properties
# Сервер
server.port=8081
server.servlet.context-path=/restaurant_war_exploded

# SQL Server
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=restaurant_dbb
spring.datasource.username=sa
spring.datasource.password=sa

# Hibernate
spring.jpa.hibernate.ddl-auto=update

# Email (Gmail SMTP)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=ваш_email@gmail.com
spring.mail.password=ваш_пароль
```

**Важно:** Для Gmail используйте "App Password" вместо обычного пароля.

## Email уведомления

Приложение отправляет email при:
1. **Регистрация** - Приветственное письмо
2. **Смена пароля** - Уведомление о смене пароля
3. **Статус заказа** - Уведомления о смене статуса заказа

## Безопасность

- ✅ Пароли хешируются с BCryptPasswordEncoder
- ✅ Spring Security с ограничением доступа по ролям
- ✅ CSRF защита
- ✅ SQL Injection защита (JPA параметризованные запросы)
- ✅ CORS настройка для API

## Возможные ошибки и решения

### 1. "Cannot resolve symbol 'User'"
**Решение:** Пересоздайте index в Maven:
```bash
./mvnw clean
./mvnw idea:idea
```

### 2. "Connection refused: localhost:1433"
**Решение:** Проверьте:
- SQL Server запущен
- Правильны хост и порт в application.properties
- Пользователь `sa` существует

### 3. "Email не отправляется"
**Решение:**
- Включите "Less secure apps" в Gmail (если используете обычный пароль)
- Используйте App Password для Gmail
- Проверьте интернет соединение

### 4. "401 Unauthorized на /admin"
**Решение:** Убедитесь, что пользователь имеет роль `ADMIN`

## Развертывание на продакшене

1. Измените пароли в `application.properties`
2. Используйте внешнюю БД вместо локальной
3. Включите HTTPS
4. Создайте отдельный Email аккаунт для приложения
5. Настройте логирование
6. Используйте `spring.jpa.hibernate.ddl-auto=validate` вместо `update`

## Примеры использования

### Регистрация пользователя
```
1. Перейдите на http://localhost:8081/restaurant_war_exploded/register
2. Заполните форму (имя, email, пароль)
3. Система отправит приветственное письмо
4. Перейдите на /login и введите данные
```

### Смена пароля
```
1. Авторизуйтесь в системе
2. Перейдите на /profile
3. Нажмите "Изменить пароль"
4. Введите старый и новый пароль
5. Система отправит уведомление на email
```

### Выдача прав администратора
```
1. Авторизуйтесь как администратор
2. Перейдите на /admin/users
3. Найдите пользователя
4. Нажмите "Сделать админом"
```

## Лицензия

MIT License - использование в коммерческих целях разрешено

## Автор

Разработано с ❤️ для системы управления рестораном

