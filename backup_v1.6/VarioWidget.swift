import WidgetKit
import SwiftUI

// MARK: - Timeline

struct VarioEntry: TimelineEntry {
    let date: Date
    let data: VarioLiveData
}

struct VarioProvider: TimelineProvider {

    func placeholder(in context: Context) -> VarioEntry {
        VarioEntry(
            date: Date(),
            data: .preview
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (VarioEntry) -> Void
    ) {
        completion(
            VarioEntry(
                date: Date(),
                data: .preview
            )
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<VarioEntry>) -> Void
    ) {

        let entry = VarioEntry(
            date: Date(),
            data: VarioDataStore.shared.data
        )

        let refresh =
            Calendar.current.date(
                byAdding: .minute,
                value: 15,
                to: Date()
            )
            ?? Date().addingTimeInterval(900)

        completion(
            Timeline(
                entries: [entry],
                policy: .after(refresh)
            )
        )
    }
}

// MARK: - Main View

struct VarioWidgetView: View {

    let entry: VarioEntry

    var body: some View {

        ZStack {

            VarioBackground()

            VStack(spacing: 0) {

                topBar

                Spacer(minLength: 3)

                mainValue

                Spacer(minLength: 4)

                VarioGauge(
                    value: entry.data.verticalSpeed
                )
                .frame(height: 42)

                Spacer(minLength: 4)

                stateIndicator

                Spacer(minLength: 5)

                telemetry
            }
            .padding(12)
        }
        .containerBackground(.black, for: .widget)
    }

    // MARK: Top Bar

    private var topBar: some View {

        HStack {

            HStack(spacing: 6) {

                Image(systemName: "location.north.fill")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(stateColor)

                Text("VARIO")
                    .font(
                        .system(
                            size: 13,
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .tracking(2.8)
                    .foregroundStyle(.white)
            }

            Spacer()

            HStack(spacing: 4) {

                Circle()
                    .fill(stateColor)
                    .frame(width: 6, height: 6)

                Text(
                    entry.data.isConnected
                    ? "LIVE"
                    : "OFFLINE"
                )
                .font(
                    .system(
                        size: 7,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .tracking(1)
                .foregroundStyle(stateColor)
            }
        }
    }

    // MARK: Main Value

    private var mainValue: some View {

        VStack(spacing: -2) {

            HStack(
                alignment: .center,
                spacing: 5
            ) {

                Text(entry.data.directionSymbol)
                    .font(
                        .system(
                            size: 26,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(stateColor)

                Text(
                    entry.data.formattedVerticalSpeed
                )
                .font(
                    .system(
                        size: 43,
                        weight: .heavy,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(.white)
                .minimumScaleFactor(0.55)
            }

            Text("m/s")
                .font(
                    .system(
                        size: 9,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .tracking(3)
                .foregroundStyle(
                    Color.white.opacity(0.45)
                )
        }
    }

    // MARK: State

    private var stateIndicator: some View {

        HStack(spacing: 6) {

            Rectangle()
                .fill(stateColor)
                .frame(width: 16, height: 2)

            Text(entry.data.stateText)
                .font(
                    .system(
                        size: 9,
                        weight: .black,
                        design: .rounded
                    )
                )
                .tracking(2)
                .foregroundStyle(stateColor)

            Rectangle()
                .fill(stateColor)
                .frame(width: 16, height: 2)
        }
    }

    // MARK: Telemetry

    private var telemetry: some View {

        HStack(spacing: 0) {

            metric(
                title: "ALT",
                value:
                    "\(entry.data.formattedAltitude)m"
            )

            separator

            metric(
                title: "PRESS",
                value:
                    entry.data.formattedPressure
            )

            if entry.data.temperature != nil {

                separator

                metric(
                    title: "TEMP",
                    value:
                        entry.data.formattedTemperature
                )
            }

            if entry.data.battery != nil {

                separator

                metric(
                    title: "BAT",
                    value:
                        entry.data.formattedBattery
                )
            }
        }
    }

    private func metric(
        title: String,
        value: String
    ) -> some View {

        VStack(spacing: 2) {

            Text(title)
                .font(
                    .system(
                        size: 6,
                        weight: .black,
                        design: .monospaced
                    )
                )
                .tracking(1)
                .foregroundStyle(
                    Color.white.opacity(0.38)
                )

            Text(value)
                .font(
                    .system(
                        size: 9,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .monospacedDigit()
                .foregroundStyle(.white)
                .minimumScaleFactor(0.65)
        }
        .frame(maxWidth: .infinity)
    }

    private var separator: some View {

        Rectangle()
            .fill(
                Color.white.opacity(0.12)
            )
            .frame(width: 1, height: 24)
    }

    // MARK: Color

    private var stateColor: Color {

        switch entry.data.flightState {

        case .climb:
            return Color.green

        case .descent:
            return Color.orange

        case .level:
            return Color.white

        case .noData:
            return Color.red
        }
    }
}

// MARK: - Background

struct VarioBackground: View {

    var body: some View {

        ZStack {

            Color.black

            LinearGradient(
                colors: [
                    Color.white.opacity(0.035),
                    Color.clear,
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RoundedRectangle(
                cornerRadius: 18
            )
            .stroke(
                Color.white.opacity(0.08),
                lineWidth: 1
            )
            .padding(1)
        }
    }
}

// MARK: - Widget

struct VarioWidget: Widget {

    let kind: String = "VarioWidget"

    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider: VarioProvider()
        ) { entry in

            VarioWidgetView(entry: entry)
        }
        .configurationDisplayName("VARIO")
        .description(
            "Aviation-style vertical speed instrument."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

// MARK: - Bundle

@main
struct VarioWidgetBundle: WidgetBundle {

    var body: some Widget {
        VarioWidget()
    }
}

// MARK: - Preview

#Preview(as: .systemMedium) {

    VarioWidget()

} timeline: {

    VarioEntry(
        date: Date(),
        data: .preview
    )

    VarioEntry(
        date: Date(),
        data: VarioLiveData(
            verticalSpeed: -2.4,
            altitude: 796,
            pressure: 1008.4,
            temperature: 17.5,
            battery: 73,
            timestamp: Date(),
            isConnected: true
        )
    )
}
