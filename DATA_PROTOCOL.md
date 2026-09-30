# VARIO DATA PROTOCOL

Version: 1

The Android VARIO application and the iPhone VARIO application use the same logical data packet.

## Fields

- protocolVersion — protocol version
- verticalSpeed — vertical speed in m/s
- altitude — altitude in meters
- pressure — atmospheric pressure in hPa
- temperature — temperature in °C, optional
- battery — battery percentage, optional
- timestamp — ISO 8601 timestamp
- isConnected — current connection state

## Example

{
  "protocolVersion": 1,
  "verticalSpeed": 2.4,
  "altitude": 184.6,
  "pressure": 991.8,
  "temperature": 18.7,
  "battery": 87,
  "timestamp": "2026-09-30T08:00:00Z",
  "isConnected": true
}

## Transport

The packet format is independent of transport.

Possible transports:

1. Bluetooth / BLE
2. Wi-Fi
3. HTTP / WebSocket
4. Internet server/API

The transport layer will be added separately.
