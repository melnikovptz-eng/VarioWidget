import Foundation

final class VarioSharedStore {

    static let shared = VarioSharedStore()

    private let suiteName = "group.com.pavel.vario"
    private let dataKey = "vario.packet.v1"

    private init() {}

    private var defaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }

    func save(_ packet: VarioPacket) throws {
        let data = try packet.encodedJSON()
        defaults?.set(data, forKey: dataKey)
    }

    func load() -> VarioPacket? {
        guard let data = defaults?.data(forKey: dataKey) else {
            return nil
        }

        return try? VarioPacket.decode(data)
    }

    func clear() {
        defaults?.removeObject(forKey: dataKey)
    }

    func saveJSON(_ json: String) throws {
        let packet = try VarioPacket.decode(json: json)
        try save(packet)
    }

    func loadJSON() -> String? {
        guard let packet = load() else {
            return nil
        }

        return try? packet.jsonString()
    }
}
