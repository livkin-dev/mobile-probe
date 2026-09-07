#!/bin/bash

# El Vigía: Mobile AI Censorship Probe
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
echo " 📡 EL VIGÍA PROBE: LLM API CENSORSHIP TEST"
echo " 🕒 Date: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
echo "=========================================================================================="
printf "%-32s | %-15s | %-4s | %-15s | %s\n" "API ENDPOINT" "IP" "STAT" "DNS/RSP/TOT(ms)" "TSPU BLOCKED?"
echo "------------------------------------------------------------------------------------------"

for url in "${ENDPOINTS[@]}"; do
    domain=$(echo "$url" | awk -F/ '{print $3}')
    
    # Извлекаем код, IP, время DNS, время до 1-го байта, общее время
    response=$(curl -A "$UA" -o /dev/null -s -w "%{http_code}:%{remote_ip}:%{time_namelookup}:%{time_starttransfer}:%{time_total}" -m 10 "$url")
    exit_code=$?

    # Парсим ответ
    status=$(echo "$response" | cut -d: -f1)
    ip=$(echo "$response" | cut -d: -f2)
    t_dns=$(echo "$response" | cut -d: -f3 | tr ',' '.')
    t_rsp=$(echo "$response" | cut -d: -f4 | tr ',' '.')
    t_tot=$(echo "$response" | cut -d: -f5 | tr ',' '.')

    if [ -z "$ip" ]; then ip="N/A"; fi

    # Переводим в миллисекунды и склеиваем в строку
    if [ -n "$t_tot" ]; then
        dns_ms=$(awk -v t="$t_dns" 'BEGIN {printf "%.0f", t * 1000}')
        rsp_ms=$(awk -v t="$t_rsp" 'BEGIN {printf "%.0f", t * 1000}')
        tot_ms=$(awk -v t="$t_tot" 'BEGIN {printf "%.0f", t * 1000}')
        timings="${dns_ms}/${rsp_ms}/${tot_ms}"
    else
        timings="N/A"
    fi

    # Вывод результатов
    if [ $exit_code -eq 0 ]; then
        if [ "$status" = "000" ]; then
            printf "%-32s | %-15s | %-4s | %-15s | ⚠️ YES (RST)\n" "$domain" "$ip" "ERR" "$timings"
        else
            printf "%-32s | %-15s | %-4s | %-15s | ✅ NO\n" "$domain" "$ip" "$status" "$timings"
        fi
    elif [ $exit_code -eq 28 ]; then
        printf "%-32s | %-15s | %-4s | %-15s | ⚠️ YES (Timeout)\n" "$domain" "$ip" "ERR" "$timings"
    else
        printf "%-32s | %-15s | %-4s | %-15s | ⚠️ YES (Drop)\n" "$domain" "$ip" "ERR" "$timings"
    fi
done
echo "=========================================================================================="
echo "✅ Test finished. Please take a screenshot or copy this output."