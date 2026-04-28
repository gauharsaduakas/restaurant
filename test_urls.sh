#!/bin/bash

# Тестовый скрипт для проверки всех URL приложения
BASE_URL="http://localhost:8081/restaurant_war_exploded"

echo "🔍 Проверка всех URL приложения..."
echo "========================================="

# Массив с URL-адресами для проверки
urls=(
    "$BASE_URL/"
    "$BASE_URL/home"
    "$BASE_URL/login"
    "$BASE_URL/register"
    "$BASE_URL/profile"
    "$BASE_URL/admin"
    "$BASE_URL/access-denied"
)

# Проверка каждого URL
for url in "${urls[@]}"; do
    echo "📍 Проверка: $url"
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")

    if [ "$status" = "200" ] || [ "$status" = "302" ] || [ "$status" = "401" ]; then
        echo "✅ OK (HTTP $status)"
    else
        echo "❌ ОШИБКА (HTTP $status)"
    fi
    echo ""
done

echo "========================================="
echo "✅ Проверка завершена!"

