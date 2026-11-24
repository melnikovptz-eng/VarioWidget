# Успешный запуск VARIO iOS UI Tests

Зафиксировано после первого полностью успешного прогона. Использовать эти параметры повторно, не подбирать окружение заново.

## Репозиторий и ветка

- Репозиторий: `melnikovptz-eng/VarioWidget`
- Тестовая ветка: `ci/vario-ios-ui-tests`
- Workflow: `.github/workflows/vario-ios-ui-tests.yml`
- Workflow запускается при Pull Request в `main` или вручную через `workflow_dispatch`.
- Основная ветка `main` не изменялась; тестовые изменения находятся в отдельной ветке и PR #1.

## Проверенное окружение

- GitHub Actions runner: `macos-15`
- Генератор проекта: XcodeGen (`xcodegen generate`)
- Xcode project: `VarioWidget.xcodeproj`
- Scheme: `Vario`
- Simulator: `iPhone 16`
- Destination: `platform=iOS Simulator,name=iPhone 16,OS=latest`
- Команда тестирования: `xcodebuild test`
- Подпись для симулятора отключена: `CODE_SIGNING_ALLOWED=NO`
- Result bundle: `$RUNNER_TEMP/VARIO-UI-Tests.xcresult`
- Лог сборки: `$RUNNER_TEMP/VARIO-xcodebuild.log`
- Скриншоты XCTest экспортируются через `xcrun xcresulttool export attachments`.
- Артефакт Actions: `vario-ios-ui-test-results`, хранение 14 дней.

## Подтверждённый успешный запуск

- GitHub Actions run ID: `45489455176`
- Результат: `TEST SUCCEEDED`
- XCTest: 1 тест выполнен, 0 ошибок.
- Тест: `testMainScreenRendersTelemetry`
- Проверены accessibility-элементы VARIO, LIVE, +2.4, CLIMB, ALT, PRESS и TEMP.
- Получен скриншот `VARIO-main-screen`.

## Исправления, необходимые для успешного запуска

1. `WidgetSources/VarioDataStore.swift`: метод `update` принимает `timestamp` и `isConnected`.
2. `VarioWidget/WidgetInfo.plist`: удалён запрещённый для WidgetKit ключ `NSExtensionPrincipalClass`.
3. В `VarioWidget/Info.plist` и `VarioWidget/WidgetInfo.plist` явно заданы `CFBundleExecutable=$(EXECUTABLE_NAME)` и `CFBundleName=$(PRODUCT_NAME)`.

Не откатывать эти исправления без отдельной проверки.

## Как повторить запуск

1. Открыть PR #1 или запустить workflow вручную.
2. Оставить runner `macos-15`, scheme `Vario` и destination `iPhone 16, OS=latest` без изменений.
3. Скачать артефакт `vario-ios-ui-test-results`, если нужны отчёт, лог или PNG скриншоты.

Workflow и параметры уже настроены. Не создавать новый workflow и не менять симулятор без причины.

## Важное ограничение проверки

Текущий XCTest подтверждает наличие элементов в accessibility tree, но не гарантирует, что все карточки видны в пределах экрана. В первом скриншоте нижние карточки визуально не отображались. Для полноценной проверки расположения добавить проверки `isHittable`/видимой области. Это отдельная задача, не причина менять успешную конфигурацию сборки.
