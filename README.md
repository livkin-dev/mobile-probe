# mobile-probe
Lightweight bash probe for detecting L3/L4 (DPI) censorship of mobile AI APIs (ChatGPT, Claude, Gemini). Part of the El Vigía project.

# Тест доступности мобильных ИИ-сервисов

Этот легковесный скрипт создан для мониторинга интернет-цензуры в России. 

Власти (РКН/ТСПУ) часто блокируют **мобильные приложения** нейросетей (ChatGPT, Claude, Gemini), даже когда их веб-версии остаются доступны. Этот скрипт проверяет доступность скрытых API-серверов, к которым обращаются мобильные приложения, и выявляет наличие сетевых блокировок.

## 🚀 Как запустить тест (Инструкция для волонтеров)

Вам не нужно быть программистом или устанавливать сложные программы. Тест занимает 30 секунд. ⚠️ **Пожалуйста, отключите VPN перед запуском теста!**

### 🍏 Для пользователей iPhone / iPad (iOS)
1. Установите бесплатное приложение **[a-Shell mini](https://apps.apple.com/us/app/a-shell-mini/id1543537943)** из App Store.
2. Откройте приложение, скопируйте команду ниже, вставьте её на черный экран и нажмите `Return` (Ввод):
   ```bash
   curl -s [https://raw.githubusercontent.com/ТВОЙ_АККАУНТ/el-vigia-llm-probe/main/mobile_probe.sh](https://raw.githubusercontent.com/ТВОЙ_АККАУНТ/el-vigia-llm-probe/main/mobile_probe.sh) | bash
