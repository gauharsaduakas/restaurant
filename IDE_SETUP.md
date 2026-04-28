# 🔧 Настройка IntelliJ IDEA для проекта Coffito Kitchen

## Импорт проекта

### 1. Откройте проект в IDE

```
File → Open → Выберите папку restaurant
```

### 2. Дождитесь индексации

IDE будет индексировать файлы (~2-5 минут). Посмотрите на прогресс в нижней части экрана.

### 3. Настройка JDK

```
File → Project Structure → Project
- Project SDK: Java 17
- Language level: 17
- Нажмите Apply и OK
```

### 4. Включение аннотаций (Lombok)

```
File → Settings → Build, Execution, Deployment → Compiler → Annotation Processors
- Отметьте "Enable annotation processing"
- Нажмите Apply и OK
```

Перезагрузите проект:
```
File → Invalidate Caches and Restart
```

## Конфигурация Maven

### 1. Проверьте Maven

```
File → Settings → Build, Execution, Deployment → Maven
- Maven home path: C:\Users\Madiyar\.m2
- User settings file: C:\Users\Madiyar\.m2\settings.xml
- Local repository: C:\Users\Madiyar\.m2\repository
```

### 2. Обновите зависимости

```
View → Tool Windows → Maven
- Нажмите иконку Reload в левой панели
- Или Right-click на root → Maven → Reload Projects
```

## Конфигурация Tomcat в IDE

### Метод 1: Через Application Server

```
1. File → Settings → Build, Execution, Deployment → Application Server
2. Нажмите "+" → Tomcat Server
3. Выберите путь: C:\apache-tomcat-10.1.50
4. Нажмите OK
```

### Метод 2: Через Run Configuration

```
1. Run → Edit Configurations...
2. Нажмите "+" → Tomcat Server → Local
3. Name: Tomcat 10
4. Application server: Tomcat 10 (выберите из списка)
5. На вкладке "Deployment":
   - Нажмите "+"
   - Выберите "Artifact"
   - Выберите "restaurant-1.0-SNAPSHOT:war"
   - Application context: /restaurant_war_exploded
6. На вкладке "Server":
   - Port: 8081
   - VM options: -Dfile.encoding=UTF-8
7. Нажмите Apply и OK
```

## Запуск приложения

### Вариант 1: Через Tomcat IDE

```
1. Убедитесь, что SQL Server запущен
2. Нажмите зеленую кнопку "Run" в верхней части экрана
3. Выберите "Tomcat 10"
4. Дождитесь развертывания (1-2 минуты)
5. IDE автоматически откроет браузер
```

### Вариант 2: Через Spring Boot

```
1. Нажмите Run в верхней части экрана
2. Выберите "RestaurantApplication"
3. Приложение запустится с embedded Tomcat
4. Откройте: http://localhost:8080/restaurant_war_exploded/
```

### Вариант 3: Через командную строку

```
# В Terminal IDE или PowerShell
mvnw.cmd spring-boot:run

# Или для развертывания в Tomcat
mvnw.cmd clean package -DskipTests
# Затем скопируйте WAR в webapps Tomcat
```

## Отладка приложения

### Включение Debug Mode

```
1. Run → Edit Configurations → Tomcat 10
2. На вкладке "Startup/Connection":
   - Отметьте "Debug"
3. Нажмите Apply и OK
4. Нажмите Shift+F9 (Debug вместо Run)
```

### Точки останова

```
1. Откройте файл исходного кода
2. Кликните на номер строки в левой панели (появится красная точка)
3. Запустите приложение в Debug mode
4. Когда код достигнет точки, IDE остановится
5. Используйте кнопки для пошагового выполнения
```

### Просмотр значений переменных

```
- Hover над переменной - появится Value
- Или откройте View → Tool Windows → Debug
- В левой панели смотрите Variables
```

## Проверка структуры проекта

### Project View должна показывать:

```
restaurant
├── .idea/
├── mvnw
├── mvnw.cmd
├── pom.xml
├── README.md
├── DEPLOYMENT.md
├── src/
│   └── main/
│       ├── java/
│       │   └── com/gauhar/restaurant/
│       │       ├── controller/          ← Контроллеры
│       │       ├── service/             ← Сервисы
│       │       ├── entity/              ← Сущности
│       │       ├── repository/          ← Репозитории
│       │       ├── security/            ← Security конфиг
│       │       ├── dto/                 ← DTO классы
│       │       └── RestaurantApplication.java
│       ├── resources/
│       │   ├── application.properties   ← Конфигурация
│       │   └── static/                  ← CSS, JS, картинки
│       └── webapp/
│           └── WEB-INF/
│               ├── views/               ← JSP файлы
│               │   ├── login.jsp
│               │   ├── register.jsp
│               │   ├── profile.jsp
│               │   ├── change-password.jsp
│               │   └── admin/
│               └── web.xml
└── target/
    └── restaurant-1.0-SNAPSHOT.war

```

Если папок нет - выполните:
```
File → Invalidate Caches and Restart
```

## Решение распространенных проблем

### Ошибка: "Cannot resolve symbol 'User'"

**Решение:**
```
1. File → Invalidate Caches and Restart
2. Right-click на project → Maven → Reload Projects
3. Если не поможет: File → Project Structure → Modules
   - Убедитесь, что Sources отмечена для src/main/java
```

### Ошибка: "No beans of type 'UserService' found"

**Решение:**
```
1. Проверьте, что UserService имеет @Service аннотацию
2. Проверьте, что RestaurantApplication.java в корне пакета
3. Перезагрузите кэш:
   File → Invalidate Caches and Restart
```

### Ошибка: "500 Internal Server Error"

**Решение:**
```
1. Откройте View → Tool Windows → Services
2. Посмотрите логи Tomcat
3. Или посмотрите файл: C:\apache-tomcat-10.1.50\logs\catalina.log
4. Поищите stack trace ошибки
```

### Ошибка при компилировании: "No plugin execution found"

**Решение:**
```
1. Right-click на pom.xml → Maven → Reload Projects
2. Или выполните: mvnw.cmd clean install -DskipTests
```

### IntelliJ зависает при запуске

**Решение:**
```
1. File → Invalidate Caches and Restart
2. Закройте все запущенные приложения
3. Или выполните через PowerShell:
   mvnw.cmd spring-boot:run
```

## Полезные горячие клавиши

| Комбинация | Действие |
|-----------|----------|
| Ctrl+Shift+F10 | Запустить текущий класс/тест |
| Shift+F9 | Debug текущего класса |
| Ctrl+Alt+Shift+F10 | Запустить с конфигурацией |
| F9 | Resume (продолжить после breakpoint) |
| F10 | Step over |
| F11 | Step into |
| Shift+F11 | Step out |
| Ctrl+F8 | Переключить breakpoint |
| Ctrl+Shift+F8 | Просмотр всех breakpoint'ов |
| Ctrl+F5 | Перезагрузить класс (Hot Swap) |
| Ctrl+Shift+Alt+L | Форматировать код |
| Alt+Shift+F | Find in files |

## Структура папок для понимания

### Java пакеты

```
com.gauhar.restaurant
├── controller/       - Веб контроллеры (@RestController, @Controller)
├── service/         - Бизнес логика (@Service)
├── entity/          - JPA сущности (@Entity)
├── repository/      - Data Access (@Repository)
├── security/        - Spring Security конфиг
├── dto/             - Data Transfer Objects
└── RestaurantApplication.java - Точка входа
```

### Веб ресурсы

```
src/main/webapp/
├── assets/          - Изображения, шрифты
├── WEB-INF/
│   ├── views/       - JSP шаблоны
│   ├── web.xml      - Конфигурация Tomcat
│   └── ...
├── static/          - CSS, JS
└── styles.css       - Общие стили
```

## Проверка работоспособности IDE

Выполните следующие проверки:

```
1. ✓ Откройте UserService.java - должен быть без ошибок
2. ✓ Откройте AuthController.java - должен быть без ошибок
3. ✓ Откройте pom.xml - должна быть зеленая галочка
4. ✓ Right-click на RestaurantApplication.java → Run
   - Должно запуститься приложение
5. ✓ Откройте http://localhost:8080/
   - Должна загрузиться страница входа
```

Если все работает - IDE настроена правильно! 🎉

## Дополнительные полезные плагины

Установите через File → Settings → Plugins:

- **Lombok** - поддержка аннотаций Lombok
- **Spring Boot Dashboard** - визуализация Spring приложений
- **Rainbow Brackets** - цветные скобки для читаемости
- **Database Tools** - интеграция с БД прямо в IDE
- **Git Integrations** - управление Git репозиторием

## Оптимизация производительности IDE

```
File → Settings → Editor → General → Code Folding
- Отметьте опции для лучшей видимости кода

File → Settings → Editor → Inspections
- Отключите лишние инспекции (Groovy, XPath и т.д.)

File → Settings → Tools → Java Compiler
- Compiler: javac
- Heap size: 1500M (или больше)
```

