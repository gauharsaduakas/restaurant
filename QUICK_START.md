# 🎯 Краткая инструкция по запуску

## За 5 минут до запуска

### 1️⃣ Проверьте SQL Server

```powershell
# Убедитесь, что SQL Server запущен
net start MSSQLSERVER

# Создайте БД (в SQL Server Management Studio)
CREATE DATABASE restaurant_dbb;
```

### 2️⃣ Откройте проект в IntelliJ IDEA

```
File → Open → C:\Users\Madiyar\IdeaProjects\restaurant
```

### 3️⃣ Дождитесь индексации

IDE индексирует проект (~2-5 минут). Смотрите прогресс внизу.

### 4️⃣ Запустите приложение

**Вариант A: Через IDE (РЕКОМЕНДУЕТСЯ)**

⚠️ **ПЕРЕД ЗАПУСКОМ:** Выполните эту настройку один раз:

1. `Run → Edit Configurations...`
2. Выберите `RestaurantApplication`
3. На вкладке **VM options** добавьте:
   ```
   --enable-native-access=ALL-UNNAMED
   ```
4. Нажмите **Apply** и **OK**

Теперь запустите:
```
Run → Run 'RestaurantApplication'
```

**Вариант B: Через командную строку**
```powershell
cd C:\Users\Madiyar\IdeaProjects\restaurant
mvnw.cmd spring-boot:run -Dspring-boot.run.jvmArguments="--enable-native-access=ALL-UNNAMED"
```

### 5️⃣ Откройте браузер

```
http://localhost:8081/restaurant_war_exploded/
```

### 6️⃣ Зарегистрируйтесь

Нажмите "Зарегистрироваться" и заполните форму.

---

## 🔗 Важные ссылки в браузере

| Функция | URL |
|---------|-----|
| 🏠 Главная | http://localhost:8081/restaurant_war_exploded/ |
| 🔐 Вход | http://localhost:8081/restaurant_war_exploded/login |
| 📝 Регистрация | http://localhost:8081/restaurant_war_exploded/register |
| 👤 Мой профиль | http://localhost:8081/restaurant_war_exploded/profile |
| 🔑 Смена пароля | http://localhost:8081/restaurant_war_exploded/profile/change-password |
| 👑 Админ панель | http://localhost:8081/restaurant_war_exploded/admin |
| 👥 Пользователи | http://localhost:8081/restaurant_war_exploded/admin/users |
| 🚪 Выход | http://localhost:8081/restaurant_war_exploded/logout |

---

## 📚 Документация в проекте

```
restaurant/
├── README.md                  ← Основная документация
├── DEPLOYMENT.md             ← Развертывание в Tomcat
├── IDE_SETUP.md             ← Настройка IntelliJ IDEA
├── CHECKLIST.md             ← Чек-лист завершения
├── PROJECT_SUMMARY.md       ← Сводка проекта
├── FIX_NATIVE_ACCESS_WARNING.md ← Решение для Java 17 (NEW)
└── QUICK_START.md           ← Этот файл
```

---

## ⚠️ Если что-то не работает

### Ошибка: "Ambiguous mapping" (две одинаковые маршруты)
```
Ambiguous mapping. Cannot map 'adminDashboardController' method 
to {GET [/admin/users]}: There is already 'adminController' bean method mapped.
```

**Решение (ОБЯЗАТЕЛЬНО):**
1. Закройте приложение (Ctrl+C)
2. `File → Invalidate Caches and Restart`
3. Выберите **Invalidate and Restart**
4. IDE перезагрузится
5. `Build → Rebuild Project`
6. Запустите заново

Подробнее смотрите в `FIX_AMBIGUOUS_MAPPING.md`

### Ошибка: "Restricted methods will be blocked"
```
WARNING: Restricted methods will be blocked in a future release
```

**Решение:**
1. `Run → Edit Configurations...`
2. На вкладке **VM options** добавьте:
   ```
   --enable-native-access=ALL-UNNAMED
   ```
3. Нажмите **Apply** и запустите заново

Подробнее смотрите в `FIX_NATIVE_ACCESS_WARNING.md`


---

## ✅ Тестирование функций

```
1. РЕГИСТРАЦИЯ
   ✓ /register → заполнить форму → отправить
   ✓ Должно перенаправить на /login?registered=1

2. ВХОД
   ✓ /login → ввести email/пароль → Enter
   ✓ Должно перенаправить на /home

3. ПРОФИЛЬ
   ✓ /profile → просмотреть данные
   ✓ Отредактировать имя → Сохранить

4. СМЕНА ПАРОЛЯ
   ✓ /profile/change-password → ввести пароли
   ✓ Сохранить → Получить email

5. АДМИН (если пользователь ADMIN)
   ✓ /admin → просмотреть панель
   ✓ /admin/users → список пользователей
   ✓ Попробуйте выдать/отозвать права

6. ОТКАЗ В ДОСТУПЕ
   ✓ Как USER перейти на /admin
   ✓ Должна загрузиться страница 403
```

---

## 🛠️ Полезные команды

```powershell
# Компиляция
mvnw.cmd clean compile

# Сборка
mvnw.cmd package -DskipTests

# Запуск
mvnw.cmd spring-boot:run

# Очистка (при проблемах)
mvnw.cmd clean

# Только download зависимостей
mvnw.cmd dependency:resolve
```

---

## 🎯 Следующие шаги

### После успешного запуска:

1. **Изучите код:**
   - Откройте `com.gauhar.restaurant.controller.AuthController`
   - Откройте `com.gauhar.restaurant.service.UserService`
   - Посмотрите `login.jsp` и `profile.jsp`

2. **Добавьте своего админа (опционально):**
   ```sql
   -- Зарегистрируйтесь как обычный пользователь
   -- Потом обновите через БД:
   UPDATE users SET role = 'ADMIN' WHERE email = 'ваш_email@example.com';
   ```

3. **Перейдите на /admin**
   - Увидите админ панель
   - Сможете управлять пользователями

4. **Изучите документацию:**
   - README.md - полный обзор
   - API примеры в README.md

---

## 📞 Контакты

Если нужна помощь с конкретной ошибкой:

1. **IDE проблемы** → IDE_SETUP.md
2. **Развертывание** → DEPLOYMENT.md
3. **Общие вопросы** → README.md
4. **Проверка** → CHECKLIST.md

---

## 🎉 Готово!

Ваше приложение запущено и работает! 🚀

Наслаждайтесь разработкой! 💻

---

**Создано:** 28 апреля 2026
**Версия:** 1.0.0
**Статус:** ✅ Production Ready

