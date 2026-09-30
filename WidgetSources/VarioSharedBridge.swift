import Foundation

enum VarioSharedBridge {

    static func save(_ packet: VarioPacket) throws {
        try VarioSharedStore.shared.save(packet)
    }

    static func load() -> VarioPacket? {
        VarioSharedStore.shared.load()
    }

    static func saveJSON(_ json: String) throws {
        try VarioSharedStore.shared.saveJSON(json)
    }

    static func loadJSON() -> String? {
        VarioSharedStore.shared.loadJSON()
    }

    static func clear() {
        VarioSharedStore.shared.clear()
    }
}
