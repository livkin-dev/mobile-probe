Мониторинг доступности ИИ-сервисов (LLM Probe)

Легковесный скрипт сбора данных о том, как цензурное оборудование (ТСПУ / Роскомнадзор) точечно блокирует API мобильных приложений нейросетей (ChatGPT, Claude, Gemini, DeepSeek), даже когда веб-версии остаются доступны.

Ваше участие помогает составить реальную карту блокировок. Тест абсолютно безопасен, не собирает личные данные и занимает 1 минуту.

---

## ⚠️ ВАЖНО: ОТКЛЮЧИТЕ VPN
Нам критически важно проверить, как работает интернет именно через вашего российского оператора связи. Если тест запустить с включенным VPN, данные будут некорректными.

---

## 🚀 Как запустить тест (Пошаговая инструкция)

Выберите ваше устройство. Установка сложных программ не потребуется.

### 🍏 iOS (iPhone / iPad)
1. Установите бесплатное приложение **[a-Shell mini](https://apps.apple.com/us/app/a-shell-mini/id1543537943)** из App Store.
2. Скопируйте команду ниже (выделите текст и нажмите «Скопировать»):
   ```bash
   curl -s [https://raw.githubusercontent.com/livkin-dev/mobile-probe/main/mobile_probe.sh](https://raw.githubusercontent.com/livkin-dev/mobile-probe/main/mobile_probe.sh) | bash
   ```
3. Откройте приложение `a-Shell mini`. Удерживайте палец на черном экране и выберите **«Вставить» (Paste)**.
4. Нажмите кнопку **return** (Ввод) на клавиатуре.
5. Сделайте скриншот результатов и отправьте нам.

### 🤖 Android
1. Установите бесплатное приложение **Termux** (рекомендуем через [F-Droid](https://f-droid.org/ru/packages/com.termux/)).
2. Скопируйте команду:
   ```bash
   curl -s [https://raw.githubusercontent.com/livkin-dev/mobile-probe/main/mobile_probe.sh](https://raw.githubusercontent.com/livkin-dev/mobile-probe/main/mobile_probe.sh) | bash
   ```
3. Откройте `Termux`. Зажмите палец на экране, выберите **«Paste» (Вставить)**.
4. Нажмите **Enter** (Ввод).
5. Сделайте скриншот таблицы и отправьте нам.

### 💻 Десктоп (macOS / Linux)
1. Откройте стандартное приложение **Терминал (Terminal)**.
2. Вставьте команду и нажмите `Enter`:
   ```bash
   curl -s [https://raw.githubusercontent.com/livkin-dev/mobile-probe/main/mobile_probe.sh](https://raw.githubusercontent.com/livkin-dev/mobile-probe/main/mobile_probe.sh) | bash
   ```
3. Сделайте скриншот результата и отправьте нам.

### 🪟 Windows (через PowerShell)
1. Нажмите меню **«Пуск»**, введите слово **PowerShell** и откройте программу.
2. Скопируйте эту команду:
   ```powershell
   $urls="[https://ios.chat.openai.com](https://ios.chat.openai.com)","[https://api.anthropic.com](https://api.anthropic.com)","[https://generativelanguage.googleapis.com](https://generativelanguage.googleapis.com)","[https://alkali.googleapis.com](https://alkali.googleapis.com)","[https://api.x.ai](https://api.x.ai)","[https://api.perplexity.ai](https://api.perplexity.ai)","[https://api.deepseek.com](https://api.deepseek.com)"; foreach($u in $urls){try{$r=Invoke-WebRequest -Uri $u -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop;Write-Host "$u | ✅ NO ($($r.StatusCode))"}catch{Write-Host "$u | ⚠️ YES (BLOCKED)"}}
   ```
3. Кликните **правой кнопкой мыши** в синем окне PowerShell (текст вставится) и нажмите `Enter`.
4. Сделайте скриншот и отправьте нам.

---

## 📊 Расшифровка результатов

* **✅ NO** (Связь есть): Зарубежный сервер получил запрос. ТСПУ пропустил трафик, блокировки на данном маршруте нет.
* **⚠️ YES** (Blocked / Timeout / RST): Запрос перехвачен. ТСПУ внутри РФ разорвал ваше соединение из-за цензуры.
