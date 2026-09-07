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

# Маскируемся под мобильный Safari для WAF
UA="Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1"

echo "=================================================================="
echo " 📡 EL VIGÍA PROBE: LLM API CENSORSHIP TEST"
echo " 🕒 Date: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
echo "=================================================================="
printf "%-35s | %-10s | %s\n" "API ENDPOINT" "STATUS" "TSPU BLOCKED?"
echo "------------------------------------------------------------------"

for url in "${ENDPOINTS[@]}"; do
    domain=$(echo "$url" | awk -F/ '{print $3}')
    
    # curl: таймаут 10с, скрываем прогресс-бар, выводим только код ответа
    status=$(curl -A "$UA" -o /dev/null -s -w "%{http_code}" -m 10 "$url")
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        if [ "$status" = "000" ]; then
            printf "%-35s | %-10s | ⚠️ YES (RST)\n" "$domain" "BLOCKED"
        else
            printf "%-35s | %-10s | ✅ NO\n" "$domain" "$status"
        fi
    elif [ $exit_code -eq 28 ]; then
        printf "%-35s | %-10s | ⚠️ YES (Timeout)\n" "$domain" "TIMEOUT"
    else
        printf "%-35s | %-10s | ⚠️ YES (Drop)\n" "$domain" "ERR $exit_code"
    fi
done
echo "=================================================================="
echo "✅ Test finished. Please take a screenshot or copy this output."