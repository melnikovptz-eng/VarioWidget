import SwiftUI

struct VarioGauge: View {

    let value: Double

    private let minimum = -5.0
    private let maximum = 5.0

    private var clampedValue: Double {
        min(max(value, minimum), maximum)
    }

    private var normalizedValue: Double {
        (clampedValue - minimum) /
        (maximum - minimum)
    }

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.10))

                Rectangle()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 2)

                HStack(spacing: 0) {

                    ForEach(0..<11) { index in

                        VStack(spacing: 2) {

                            Rectangle()
                                .fill(
                                    Color.white.opacity(
                                        index == 5 ? 0.8 : 0.25
                                    )
                                )
                                .frame(
                                    width: index == 5 ? 2 : 1,
                                    height: index % 2 == 0 ? 8 : 5
                                )

                            if index % 2 == 0 {

                                Text("\(index - 5)")
                                    .font(
                                        .system(
                                            size: 7,
                                            weight: .medium
                                        )
                                    )
                                    .foregroundStyle(.secondary)
                            }
                        }

                        if index < 10 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 5)

                GeometryReader { gaugeGeometry in

                    let x =
                        normalizedValue *
                        gaugeGeometry.size.width

                    Capsule()
                        .fill(Color.white)
                        .frame(
                            width: 4,
                            height:
                                gaugeGeometry.size.height * 0.65
                        )
                        .position(
                            x: x,
                            y:
                                gaugeGeometry.size.height / 2
                        )
                }
            }
        }
        .frame(height: 38)
    }
}
