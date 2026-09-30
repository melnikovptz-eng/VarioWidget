# VARIO v1.9 — MAC / XCODE BUILD

1. Распаковать VARIO_Widget_v1.8.zip на Mac.
2. Установить Xcode 15+.
3. Установить XcodeGen.
4. В терминале открыть папку проекта.
5. Выполнить:

xcodegen generate

6. Открыть:
VarioWidget.xcodeproj

7. В Xcode проверить Signing & Capabilities:
   App Group:
   group.com.pavel.vario

8. Выбрать iPhone Simulator или подключённый iPhone.
9. Build / Run.

Важно:
финальная сборка iOS выполняется на macOS/Xcode.
Termux используется для подготовки исходников.
