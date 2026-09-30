import SwiftUI

@main
struct VarioApp: App {

    var body: some Scene {
        WindowGroup {
            VarioMainView()
        }
    }
}

struct VarioMainView: View {

    @State private var data = VarioDataStore.shared.data

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 18) {

                HStack {
                    Text("VARIO")
                        .font(.system(size: 22, weight: .bold))
                        .tracking(2)

                    Spacer()

                    Circle()
                        .fill(data.isConnected ? Color.green : Color.red)
                        .frame(width: 9, height: 9)

                    Text(data.isConnected ? "LIVE" : "OFFLINE")
                        .font(.system(size: 12, weight: .bold))
                }

                Spacer()

                Text(data.formattedVerticalSpeed)
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()

                Text(data.stateText)
                    .font(.system(size: 15, weight: .bold))
                    .tracking(2)

                Divider()
                    .overlay(Color.gray.opacity(0.35))

                HStack {
                    metric("ALT", data.formattedAltitude)
                    metric("PRESS", data.formattedPressure)
                    metric("TEMP", data.formattedTemperature)
                }

                Spacer()

                Text("VARIO v1.6")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .foregroundStyle(.white)
        }
    }

    private func metric(_ title: String, _ value: String) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
    }
}
