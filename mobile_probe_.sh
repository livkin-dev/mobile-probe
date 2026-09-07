#!/bin/bash

# Mobile AI Censorship Probe
# Detects DPI intervention (TCP RST, Blackholing) against LLM APIs

ENDPOINTS=(
    "https://ios.chat.openai.com"
    "https://android.chat.openai.com"
    "https://auth0.openai.com"
    "https://api.anthropic.com"
    "https://generativelanguage.googleapis.com"
    "https://alkali.googleapis.com"
    "https://api.x.ai"
    "https://api.perplexity.ai"
    "https://api.deepseek.com"
)

UA="Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1"

echo "=========================================================================================="
echo " 📡 PROBE: LLM API CENSORSHIP TEST"
echo " 🕒 Date: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
echo "=========================================================================================="
printf "%-35s | %-15s | %-6s | %-9s | %s\n" "API ENDPOINT" "IP" "STATUS" "TIME(ms)" "TSPU BLOCKED?"
echo "------------------------------------------------------------------------------------------"

for url in "${ENDPOINTS[@]}"; do
    domain=$(echo "$url" | awk -F/ '{print $3}')
    
    # Запрашиваем код ответа, IP и время через разделитель ":"
    # %{http_code} - HTTP статус
    # %{remote_ip} - IP адрес целевого узла
    # %{time_total} - общее время в секундах
    response=$(curl -A "$UA" -o /dev/null -s -w "%{http_code}:%{remote_ip}:%{time_total}" -m 10 "$url")
    exit_code=$?

    # Разбиваем ответ на переменные
    status=$(echo "$response" | cut -d: -f1)
    ip=$(echo "$response" | cut -d: -f2)
    time_total=$(echo "$response" | cut -d: -f3)

    # Чиним локали (если система отдает время с запятой вместо точки)
    time_total=$(echo "$time_total" | tr ',' '.')

    # Если IP не определился (сбой DNS или таймаут)
    if [ -z "$ip" ]; then
        ip="N/A"
    fi

    # Переводим секунды в миллисекунды для красоты (как в Python)
    if [ -n "$time_total" ]; then
        time_ms=$(awk -v t="$time_total" 'BEGIN {printf "%.1f", t * 1000}')
    else
        time_ms="N/A"
    fi

    if [ $exit_code -eq 0 ]; then
        if [ "$status" = "000" ]; then
            printf "%-35s | %-15s | %-6s | %-9s | ⚠️ YES (RST)\n" "$domain" "$ip" "BLOCKED" "$time_ms"
        else
            printf "%-35s | %-15s | %-6s | %-9s | ✅ NO\n" "$domain" "$ip" "$status" "$time_ms"
        fi
    elif [ $exit_code -eq 28 ]; then
        printf "%-35s | %-15s | %-6s | %-9s | ⚠️ YES (Timeout)\n" "$domain" "$ip" "TIMEOUT" "$time_ms"
    else
        printf "%-35s | %-15s | %-6s | %-9s | ⚠️ YES (Drop)\n" "$domain" "$ip" "ERR $exit_code" "$time_ms"
    fi
done
echo "=========================================================================================="
echo "✅ Test finished. Please take a screenshot or copy this output."
