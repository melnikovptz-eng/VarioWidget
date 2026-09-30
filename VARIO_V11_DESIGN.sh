#!/data/data/com.termux/files/usr/bin/bash
set -e

PROJECT="$HOME/VarioWidget"
SRC="$PROJECT/VarioWidget"

echo "============================================================"
echo "              VARIO WIDGET v1.1 DESIGN"
echo "============================================================"

mkdir -p "$SRC"

[ -f "$SRC/VarioWidget.swift" ] && \
cp "$SRC/VarioWidget.swift" "$SRC/VarioWidget.swift.v10"

cat > "$SRC/VarioWidget.swift" <<'SWIFT'
import WidgetKit
import SwiftUI

struct VarioEntry: TimelineEntry {
    let date: Date
    let data: VarioLiveData
}

struct VarioProvider: TimelineProvider {

    func placeholder(in context: Context) -> VarioEntry {
        VarioEntry(date: Date(), data: .preview)
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (VarioEntry) -> Void
    ) {
        completion(
            VarioEntry(date: Date(), data: .preview)
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

        let nextUpdate =
            Calendar.current.date(
                byAdding: .minute,
                value: 15,
                to: Date()
            )
            ?? Date().addingTimeInterval(900)

        completion(
            Timeline(
                entries: [entry],
                policy: .after(nextUpdate)
            )
        )
    }
}

struct VarioWidgetView: View {

    let entry: VarioEntry

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                Color.black

                VStack(spacing: 0) {

                    header

                    Spacer(minLength: 4)

                    speedBlock

                    Spacer(minLength: 5)

                    VarioGauge(
                        value: entry.data.verticalSpeed
                    )
                    .frame(
                        height:
                            geometry.size.height * 0.20
                    )

                    Spacer(minLength: 5)

                    flightState

                    Spacer(minLength: 5)

                    telemetry
                }
                .padding(12)
            }
        }
        .containerBackground(.black, for: .widget)
    }

    private var header: some View {

        HStack {

            Text("VARIO")
                .font(
                    .system(
                        size: 13,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .tracking(2.5)
                .foregroundStyle(.white)

            Spacer()

            Circle()
                .fill(
                    entry.data.isConnected
                    ? Color.green
                    : Color.red
                )
                .frame(width: 7, height: 7)

            Text(
                entry.data.isConnected
                ? "LIVE"
                : "OFFLINE"
            )
            .font(
                .system(
                    size: 8,
                    weight: .bold,
                    design: .monospaced
                )
            )
            .foregroundStyle(
                entry.data.isConnected
                ? Color.green
                : Color.red
            )
        }
    }

    private var speedBlock: some View {

        VStack(spacing: 0) {

            HStack(
                alignment: .center,
                spacing: 7
            ) {

                Text(entry.data.directionSymbol)
                    .font(
                        .system(
                            size: 30,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(stateColor)

                Text(
                    entry.data.formattedVerticalSpeed
                )
                .font(
                    .system(
                        size: 45,
                        weight: .heavy,
                        design: .rounded
                    )
                )
                .monospacedDigit()
                .foregroundStyle(.white)
                .minimumScaleFactor(0.65)
            }

            Text("m/s")
                .font(
                    .system(
                        size: 11,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .tracking(2)
                .foregroundStyle(.gray)
        }
    }

    private var flightState: some View {

        Text(entry.data.stateText)
            .font(
                .system(
                    size: 11,
                    weight: .bold,
                    design: .rounded
                )
            )
            .tracking(2)
            .foregroundStyle(stateColor)
            .frame(maxWidth: .infinity)
    }

    private var telemetry: some View {

        HStack(spacing: 0) {

            telemetryItem(
                title: "ALT",
                value:
                    "\(entry.data.formattedAltitude) m"
            )

            Divider()
                .frame(height: 28)
                .overlay(
                    Color.gray.opacity(0.35)
                )

            telemetryItem(
                title: "PRESS",
                value:
                    entry.data.formattedPressure
            )

            if entry.data.temperature != nil {

                Divider()
                    .frame(height: 28)
                    .overlay(
                        Color.gray.opacity(0.35)
                    )

                telemetryItem(
                    title: "TEMP",
                    value:
                        entry.data.formattedTemperature
                )
            }

            if entry.data.battery != nil {

                Divider()
                    .frame(height: 28)
                    .overlay(
                        Color.gray.opacity(0.35)
                    )

                telemetryItem(
                    title: "BAT",
                    value:
                        entry.data.formattedBattery
                )
            }
        }
    }

    private func telemetryItem(
        title: String,
        value: String
    ) -> some View {

        VStack(spacing: 2) {

            Text(title)
                .font(
                    .system(
                        size: 7,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(.gray)

            Text(value)
                .font(
                    .system(
                        size: 10,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }

    private var stateColor: Color {

        switch entry.data.flightState {

        case .climb:
            return .green

        case .descent:
            return .orange

        case .level:
            return .white

        case .noData:
            return .red
        }
    }
}

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
            "Vertical speed, altitude, pressure and flight status."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

@main
struct VarioWidgetBundle: WidgetBundle {

    var body: some Widget {
        VarioWidget()
    }
}

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
            verticalSpeed: -2.1,
            altitude: 796,
            pressure: 1008.4,
            temperature: 17.5,
            battery: 73,
            timestamp: Date(),
            isConnected: true
        )
    )
}
SWIFT

echo
echo "===== V1.1 SOURCE CREATED ====="

FAIL=0

for f in \
    VarioWidget.swift \
    VarioDataStore.swift \
    VarioGauge.swift
do
    if [ -f "$SRC/$f" ]; then
        echo "OK   $f"
    else
        echo "FAIL $f"
        FAIL=1
    fi
done

grep -q "VarioGauge" "$SRC/VarioWidget.swift" \
    && echo "OK   Gauge connected" \
    || { echo "FAIL Gauge"; FAIL=1; }

grep -q "VarioLiveData" "$SRC/VarioWidget.swift" \
    && echo "OK   Data model connected" \
    || { echo "FAIL Data model"; FAIL=1; }

grep -q "systemSmall" "$SRC/VarioWidget.swift" \
    && echo "OK   Small widget" \
    || { echo "FAIL Small widget"; FAIL=1; }

grep -q "systemMedium" "$SRC/VarioWidget.swift" \
    && echo "OK   Medium widget" \
    || { echo "FAIL Medium widget"; FAIL=1; }

grep -q "verticalSpeed" "$SRC/VarioWidget.swift" \
    && echo "OK   Vertical speed" \
    || { echo "FAIL Vertical speed"; FAIL=1; }

grep -q "formattedAltitude" "$SRC/VarioWidget.swift" \
    && echo "OK   Altitude" \
    || { echo "FAIL Altitude"; FAIL=1; }

grep -q "formattedPressure" "$SRC/VarioWidget.swift" \
    && echo "OK   Pressure" \
    || { echo "FAIL Pressure"; FAIL=1; }

grep -q "formattedTemperature" "$SRC/VarioWidget.swift" \
    && echo "OK   Temperature" \
    || { echo "FAIL Temperature"; FAIL=1; }

grep -q "formattedBattery" "$SRC/VarioWidget.swift" \
    && echo "OK   Battery" \
    || { echo "FAIL Battery"; FAIL=1; }

echo
echo "===== FILES ====="
wc -l \
    "$SRC/VarioWidget.swift" \
    "$SRC/VarioDataStore.swift" \
    "$SRC/VarioGauge.swift"

echo
echo "===== RESULT ====="

if [ "$FAIL" -eq 0 ]; then
    echo "✅ VARIO v1.1 DESIGN: PASS"
else
    echo "❌ VARIO v1.1 DESIGN: FAIL"
fi

echo "============================================================"
