# VARIO APP GROUP

Version: 1

App Group identifier:

group.com.pavel.vario

Purpose:

The iPhone VARIO application and VARIO Widget use the same shared storage.

Flow:

iPhone VARIO App
       |
       v
App Group
       |
       v
VARIO Widget

Stored object:

VarioPacket v1

Storage:

UserDefaults suite:
group.com.pavel.vario

Key:

vario.packet.v1

The Android application does NOT access the App Group directly.

Android data must first reach the iPhone VARIO application through
a transport such as BLE, Wi-Fi, HTTP/WebSocket or another bridge.
