import Foundation

enum VarioDataFlowTest {
    static func test() -> Bool {
        let packet = VarioPacket(
            verticalSpeed: 2.4,
            altitude: 184.6,
            pressure: 991.8,
            temperature: 18.7,
            battery: 87,
            isConnected: true
        )

        do {
            try VarioSharedStore.shared.save(packet)
            guard let result = VarioSharedStore.shared.load() else { return false }

            return result.protocolVersion == packet.protocolVersion &&
                   result.verticalSpeed == packet.verticalSpeed &&
                   result.altitude == packet.altitude &&
                   result.pressure == packet.pressure &&
                   result.temperature == packet.temperature &&
                   result.battery == packet.battery &&
                   result.isConnected == packet.isConnected
        } catch {
            return false
        }
    }
}
