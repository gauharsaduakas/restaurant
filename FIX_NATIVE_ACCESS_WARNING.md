# ⚠️ Решение ошибки: "Restricted methods will be blocked"

## Проблема

При запуске приложения через Spring Boot вы получаете:
```
WARNING: Restricted methods will be blocked in a future release unless native access is enabled
```

Это происходит потому что Java 17 ограничивает доступ к native методам Tomcat.

## Решение

### Вариант 1: IDE (IntelliJ IDEA) ✅ РЕКОМЕНДУЕТСЯ

1. Откройте `Run → Edit Configurations...`
2. Выберите конфигурацию `RestaurantApplication`
3. На вкладке **VM options** добавьте:
```
--enable-native-access=ALL-UNNAMED
```

4. Нажмите **Apply** и **OK**
5. Запустите приложение заново

### Вариант 2: Командная строка

```powershell
cd C:\Users\Madiyar\IdeaProjects\restaurant

# Запустите с параметром
mvnw.cmd spring-boot:run -Dspring-boot.run.jvmArguments="--enable-native-access=ALL-UNNAMED"
```

### Вариант 3: Maven Wrapper конфиг

Создайте файл `.mvn/jvm.config`:

```
--enable-native-access=ALL-UNNAMED
```

### Вариант 4: Через IDE Run Configuration для Tomcat

Если используете Tomcat сервер через IDE:

1. `Run → Edit Configurations...`
2. Выберите конфигурацию Tomcat
3. На вкладке **Startup/Connection** → **VM options**:
```
--enable-native-access=ALL-UNNAMED
```

## После применения

Перезагрузите приложение:
```powershell
# Ctrl+C если запущено
mvnw.cmd spring-boot:run
```

Должно запуститься без предупреждений.

## Если всё равно не работает

Полный список параметров для Java 17:

```powershell
mvnw.cmd spring-boot:run ^
  -Dspring-boot.run.jvmArguments="--enable-native-access=ALL-UNNAMED -XX:+UseG1GC -Xms512m -Xmx1024m"
```

Где:
- `--enable-native-access=ALL-UNNAMED` - разрешить native методы
- `-XX:+UseG1GC` - использовать G1 garbage collector
- `-Xms512m` - минимум памяти 512MB
- `-Xmx1024m` - максимум памяти 1024MB

## Дополнительно

Если вы хотите полностью избежать этих предупреждений, можно использовать Java 21 LTS вместо Java 17. Но Java 17 должна работать с этим параметром.

