# 🔧 Решение ошибки: "Ambiguous mapping"

## Проблема

```
Ambiguous mapping. Cannot map 'adminDashboardController' method 
AdminDashboardController#listUsers(Model)
to {GET [/admin/users]}: There is already 'adminController' bean method
AdminController#getUsers(Model) mapped.
```

**Причина:** Есть два контроллера с одинаковыми маршрутами `/admin/users`.

## Решение

### Шаг 1: Очистить кэш IntelliJ IDEA ✅ ОБЯЗАТЕЛЬНО

1. Закройте приложение (Ctrl+C если запущено)
2. В IntelliJ IDEA нажмите:
   ```
   File → Invalidate Caches and Restart
   ```
3. Выберите:
   - ✅ Invalidate and Restart
   - ✅ Clear file system cache and Local History
4. IDE перезагрузится (1-2 минуты)

### Шаг 2: Очистить Maven кэш

```powershell
cd C:\Users\Madiyar\IdeaProjects\restaurant

# Полная очистка
mvnw.cmd clean

# Пересоздайте проект в IDE
File → Project Structure → Modules
- Right-click на module → Load/Unload Modules
```

### Шаг 3: Перестройте проект

```powershell
# В IntelliJ IDEA:
Build → Rebuild Project

# Или через командную строку:
mvnw.cmd clean compile
```

### Шаг 4: Удалите артефакты (если было развертывание в Tomcat)

Если вы развертывали в Tomcat:
```powershell
# Остановите Tomcat
net stop Tomcat10

# Удалите старое развертывание
Remove-Item "C:\apache-tomcat-10.1.50\webapps\restaurant-1.0-SNAPSHOT" -Recurse -Force
Remove-Item "C:\apache-tomcat-10.1.50\webapps\restaurant-1.0-SNAPSHOT.war" -Force

# Перезагрузите
net start Tomcat10
```

### Шаг 5: Запустите заново

```powershell
# Вариант A: Через IDE
Run → Run 'RestaurantApplication'

# Вариант B: Через командную строку
mvnw.cmd spring-boot:run -Dspring-boot.run.jvmArguments="--enable-native-access=ALL-UNNAMED"
```

## Что было сделано

✅ Удален старый файл `AdminController.java`  
✅ Оставлен `AdminDashboardController.java` с полной функциональностью  
✅ Все маршруты уникальны  

## Если всё равно не работает

1. **Проверьте, что файл действительно удален:**
   ```powershell
   Test-Path "C:\Users\Madiyar\IdeaProjects\restaurant\src\main\java\com\gauhar\restaurant\controller\AdminController.java"
   # Должно вернуть: False
   ```

2. **Проверьте, что нет других конфликтов:**
   ```
   Run → Edit Configurations
   - Убедитесь, что выбран RestaurantApplication
   - На вкладке VM options: --enable-native-access=ALL-UNNAMED
   ```

3. **Проверьте папку target:**
   ```powershell
   Remove-Item "C:\Users\Madiyar\IdeaProjects\restaurant\target" -Recurse -Force
   
   # Пересоздайте:
   mvnw.cmd clean compile
   ```

## Быстрая проверка

После всех шагов выполните:

```powershell
cd C:\Users\Madiyar\IdeaProjects\restaurant

# Проверьте, что файл действительно удален
ls src\main\java\com\gauhar\restaurant\controller\*.java | grep -i admin

# Должно показать только:
# AdminDashboardController.java

# Компилируйте
mvnw.cmd clean compile

# Если ошибок нет - всё работает!
```

## Логика

- ✅ `AdminDashboardController.java` - основной контроллер для админ функций
- ✅ `AdminController.java` - УДАЛЕН (был конфликт)
- ✅ Все маршруты в одном контроллере
- ✅ Без дублей

Приложение должно запуститься! 🚀

