import Foundation

struct VarioLiveData: Codable {

    var verticalSpeed: Double
    var altitude: Double
    var pressure: Double
    var temperature: Double?
    var battery: Int?
    var timestamp: Date
    var isConnected: Bool

    var flightState: FlightState {

        if !isConnected {
            return .noData
        }

        if verticalSpeed > 0.15 {
            return .climb
        }

        if verticalSpeed < -0.15 {
            return .descent
        }

        return .level
    }

    var directionSymbol: String {

        switch flightState {
        case .climb:
            return "arrow.up"
        case .descent:
            return "arrow.down"
        case .level:
            return "minus"
        case .noData:
            return "exclamationmark.triangle"
        }
    }

    var stateText: String {

        switch flightState {
        case .climb:
            return "CLIMB"
        case .descent:
            return "DESCENT"
        case .level:
            return "LEVEL"
        case .noData:
            return "NO DATA"
        }
    }

    var formattedVerticalSpeed: String {

        if !isConnected {
            return "--.-"
        }

        return String(format: "%+.1f", verticalSpeed)
    }

    var formattedAltitude: String {

        if !isConnected {
            return "---"
        }

        return String(format: "%.0f", altitude)
    }

    var formattedPressure: String {

        if !isConnected {
            return "----.-"
        }

        return String(format: "%.1f", pressure)
    }

    var formattedTemperature: String {

        guard let temperature else {
            return "--"
        }

        return String(format: "%.1f", temperature)
    }

    var formattedBattery: String {

        guard let battery else {
            return "--"
        }

        return "\(battery)"
    }
}

enum FlightState: String, Codable {
    case climb
    case level
    case descent
    case noData
}

extension VarioLiveData {

    static let preview = VarioLiveData(
        verticalSpeed: 2.4,
        altitude: 245.0,
        pressure: 1013.2,
        temperature: 22.5,
        battery: 87,
        timestamp: Date(),
        isConnected: true
    )

    static let disconnected = VarioLiveData(
        verticalSpeed: 0,
        altitude: 0,
        pressure: 0,
        temperature: nil,
        battery: nil,
        timestamp: Date(),
        isConnected: false
    )
}

final class VarioDataStore {

    static let shared = VarioDataStore()

    private init() {}

    private(set) var data: VarioLiveData = .preview

    func update(
        verticalSpeed: Double,
        altitude: Double,
        pressure: Double,
        temperature: Double?,
        battery: Int?
    ) {

        data = VarioLiveData(
            verticalSpeed: verticalSpeed,
            altitude: altitude,
            pressure: pressure,
            temperature: temperature,
            battery: battery,
            timestamp: Date(),
            isConnected: true
        )
    }

    func disconnect() {
        data = .disconnected
    }
}
