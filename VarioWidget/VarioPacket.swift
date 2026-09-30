import Foundation

struct VarioPacket: Codable {
    let protocolVersion: Int
    let verticalSpeed: Double
    let altitude: Double
    let pressure: Double
    let temperature: Double?
    let battery: Int?
    let timestamp: Date
    let isConnected: Bool

    init(
        verticalSpeed: Double,
        altitude: Double,
        pressure: Double,
        temperature: Double? = nil,
        battery: Int? = nil,
        timestamp: Date = Date(),
        isConnected: Bool = true
    ) {
        self.protocolVersion = 1
        self.verticalSpeed = verticalSpeed
        self.altitude = altitude
        self.pressure = pressure
        self.temperature = temperature
        self.battery = battery
        self.timestamp = timestamp
        self.isConnected = isConnected
    }

    func encodedJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return try encoder.encode(self)
    }

    func jsonString() throws -> String {
        let data = try encodedJSON()
        return String(data: data, encoding: .utf8) ?? ""
    }

    static func decode(_ data: Data) throws -> VarioPacket {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(VarioPacket.self, from: data)
    }

    static func decode(json: String) throws -> VarioPacket {
        try decode(Data(json.utf8))
    }
}
