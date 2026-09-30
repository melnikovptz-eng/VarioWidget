import Foundation

enum VarioDataBridge {

    static func apply(_ packet: VarioPacket) {
        VarioDataStore.shared.update(
            verticalSpeed: packet.verticalSpeed,
            altitude: packet.altitude,
            pressure: packet.pressure,
            temperature: packet.temperature,
            battery: packet.battery,
            timestamp: packet.timestamp,
            isConnected: packet.isConnected
        )
    }

    static func apply(json: String) throws {
        let packet = try VarioPacket.decode(json: json)
        apply(packet)
    }
}
