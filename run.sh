#!/bin/bash
cd "$(dirname "$0")"
echo "=================================================="
echo "Restaurant App - Проверка и запуск"
echo "=================================================="
echo ""
echo "Шаг 1: Очистка и компиляция проекта..."
./mvnw clean compile -q
if [ $? -ne 0 ]; then
    echo "❌ Ошибка компиляции!"
    exit 1
fi
echo "✅ Компиляция успешна"
echo ""
echo "Шаг 2: Сборка приложения..."
./mvnw package -DskipTests -q
if [ $? -ne 0 ]; then
    echo "❌ Ошибка сборки!"
    exit 1
fi
echo "✅ Сборка успешна"
echo ""
echo "Шаг 3: Запуск приложения..."
echo "Приложение будет доступно по адресу: http://localhost:8081/restaurant"
echo "Для выхода нажмите Ctrl+C"
echo ""
./mvnw spring-boot:run

