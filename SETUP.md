# RPGAlarm — Инструкция по настройке Xcode

## 1. Создать проект в Xcode

1. Xcode → **File > New > Project**
2. Выбрать **iOS > App**
3. Настройки:
   - Product Name: `RPGAlarm`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Deployment target: **iOS 16.0**
4. Сохранить в папку `/Users/dennis/Dev/my-project/RPGAlarm/`
   (заменить сгенерированный `ContentView.swift` и `RPGAlarmApp.swift` файлами из этого проекта)

## 2. Добавить SPM-зависимость (Confetti)

1. **File > Add Package Dependencies...**
2. Вставить URL: `https://github.com/simibac/ConfettiSwiftUI`
3. Нажать **Add Package**
4. Выбрать target: `RPGAlarm`

## 3. Добавить файл звука будильника

1. Скопировать файл `alarm.caf` в папку `Resources/Sounds/`
2. В Xcode перетащить его в дерево проекта → убедиться что **Target Membership: RPGAlarm** ✓
3. Если нет готового `.caf` — конвертировать любой `.mp3`/`.wav`:
   ```
   afconvert -f caff -d LEI16 input.mp3 alarm.caf
   ```

## 4. Добавить Capability: Background Modes

1. Выбрать target `RPGAlarm` → вкладка **Signing & Capabilities**
2. Нажать **+ Capability** → **Background Modes**
3. Поставить галочку: **Audio, AirPlay, and Picture in Picture**

## 5. Обновить Info.plist

Добавить два ключа:

```xml
<key>NSUserNotificationUsageDescription</key>
<string>RPG Alarm нужны уведомления, чтобы будить вас в нужное время.</string>
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>fetch</string>
</array>
```

> В Xcode 14+ Info.plist редактируется через target → **Info** вкладка, или через правой кнопкой мыши → Open as Source Code.

## 6. Добавить все Swift-файлы в проект

Перетащить в Xcode все папки:
- `App/`, `Models/`, `ViewModels/`, `Views/`, `Components/`, `Services/`, `Extensions/`

Убедиться что у каждого файла стоит **Target Membership: RPGAlarm** ✓

## 7. Запуск

- **Симулятор**: полный игровой цикл работает. Уведомления в симуляторе не срабатывают по расписанию — запускать игру через кнопку в `RootView` для теста.
- **Физическое устройство**: обязательно для тестирования будильника, звука на беззвучном режиме и уведомлений.

## Структура файлов

```
RPGAlarmApp.swift           — точка входа @main
App/AppDelegate.swift       — делегат уведомлений
Models/                     — GamePhase, AlarmModel, MathQuestion
ViewModels/                 — GameViewModel, AlarmViewModel
Services/                   — NotificationService, AudioService
Views/Alarm/                — AlarmListView, AlarmEditView
Views/Game/                 — ActiveGameView, MathGameView, TimingGameView, MemoryGameView, WinView
Components/                 — RPGCardView, RPGButtonStyle
Extensions/                 — Color+RPG, View+FadeIn
```
