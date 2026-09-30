# VARIO v1.6 ARCHITECTURE

The project is now separated into two Xcode targets.

## iPhone App

Target:
Vario

Bundle ID:
com.pavel.vario

Source:
AppSources/

Responsibilities:
- Main VARIO interface
- Receiving sensor data
- Saving data into App Group
- Future Bluetooth/Wi-Fi/network transport

## Widget Extension

Target:
VarioWidgetExtension

Bundle ID:
com.pavel.vario.widget

Source:
WidgetSources/

Responsibilities:
- WidgetKit interface
- Reading shared data
- Displaying vertical speed
- Displaying altitude / pressure / temperature
- Aviation gauge

## Shared Storage

App Group:

group.com.pavel.vario

The iPhone application writes VarioPacket data.
The widget reads the same data.

## Important

Android VARIO does not directly access the iOS App Group.

The future transport path is:

Android VARIO
      |
      v
Transport
      |
      v
iPhone VARIO App
      |
      v
App Group
      |
      v
VARIO Widget
