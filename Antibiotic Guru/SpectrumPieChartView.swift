import SwiftUI

struct SpectrumPieChartView: View {
    let bacteria: [Bacterium]
    let coverageMap: [String: CoverageLevel]
    let highlightedBacteria: Set<String>
    let categoryFilter: BacteriaCategory?

    private let uncoveredColor = Color(red: 0.75, green: 0.78, blue: 0.82)
    private let partialColor = Color.yellow
    private let fullColor = Color.green
    private let highlightColor = Color.orange

    private var filteredBacteria: [Bacterium] {
        if let filter = categoryFilter {
            return bacteria.filter { $0.category == filter }
        }
        return bacteria
    }

    private var sliceAngle: Double {
        360.0 / Double(filteredBacteria.count)
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let isCompact = horizontalSizeClass == .compact
            let pieRadius = size * (isCompact ? 0.30 : 0.32)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)

            ZStack {
                // Draw pie slices
                ForEach(Array(filteredBacteria.enumerated()), id: \.element.id) { index, bacterium in
                    let startAngle = Double(index) * sliceAngle - 90
                    let endAngle = startAngle + sliceAngle

                    PieSlice(startAngle: .degrees(startAngle), endAngle: .degrees(endAngle))
                        .fill(sliceColor(for: bacterium))
                        .overlay(
                            PieSlice(startAngle: .degrees(startAngle), endAngle: .degrees(endAngle))
                                .stroke(Color.white, lineWidth: 1.5)
                        )
                        .frame(width: pieRadius * 2, height: pieRadius * 2)
                        .position(center)
                }

                // Draw labels outside the pie with lines
                ForEach(Array(filteredBacteria.enumerated()), id: \.element.id) { index, bacterium in
                    let startAngle = Double(index) * sliceAngle - 90
                    let midAngleDeg = startAngle + sliceAngle / 2.0
                    let midAngleRad = midAngleDeg * .pi / 180

                    // Line from pie edge to label
                    let lineStart = CGPoint(
                        x: center.x + (pieRadius + 4) * cos(midAngleRad),
                        y: center.y + (pieRadius + 4) * sin(midAngleRad)
                    )
                    let lineEnd = CGPoint(
                        x: center.x + (pieRadius + size * 0.12) * cos(midAngleRad),
                        y: center.y + (pieRadius + size * 0.12) * sin(midAngleRad)
                    )

                    Path { path in
                        path.move(to: lineStart)
                        path.addLine(to: lineEnd)
                    }
                    .stroke(Color.secondary.opacity(0.5), lineWidth: 1)

                    // Label text
                    let labelRadius = pieRadius + size * (isCompact ? 0.16 : 0.18)
                    let labelX = center.x + labelRadius * cos(midAngleRad)
                    let labelY = center.y + labelRadius * sin(midAngleRad)
                    let fontSize: CGFloat = isCompact ? 8 : 11

                    Text(bacterium.shortName)
                        .font(.system(size: fontSize, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize()
                        .position(x: labelX, y: labelY)
                }

                // Category labels (outermost ring)
                ForEach(categoryLabelPositions(filteredBacteria), id: \.category.rawValue) { info in
                    let angleRad = info.angle * .pi / 180
                    let catRadius = pieRadius + size * (isCompact ? 0.28 : 0.30)
                    let x = center.x + catRadius * cos(angleRad)
                    let y = center.y + catRadius * sin(angleRad)
                    let fontSize: CGFloat = isCompact ? 10 : 14

                    Text(info.category.rawValue)
                        .font(.system(size: fontSize, weight: .bold))
                        .foregroundColor(.primary)
                        .position(x: x, y: y)
                }
            }
        }
    }

    private func sliceColor(for bacterium: Bacterium) -> Color {
        if !highlightedBacteria.isEmpty {
            return highlightedBacteria.contains(bacterium.id) ? highlightColor : uncoveredColor
        }
        guard let level = coverageMap[bacterium.id] else { return uncoveredColor }
        switch level {
        case .none: return uncoveredColor
        case .partial: return partialColor
        case .full: return fullColor
        }
    }

    private struct CategoryLabelInfo {
        let category: BacteriaCategory
        let angle: Double
    }

    private func categoryLabelPositions(_ bacteria: [Bacterium]) -> [CategoryLabelInfo] {
        var result: [CategoryLabelInfo] = []
        var currentCategory: BacteriaCategory?
        var categoryStart = 0
        var categoryCount = 0

        for (index, bact) in bacteria.enumerated() {
            if bact.category != currentCategory {
                if let cat = currentCategory {
                    let midIndex = Double(categoryStart) + Double(categoryCount) / 2.0
                    let angle = midIndex * sliceAngle - 90
                    result.append(CategoryLabelInfo(category: cat, angle: angle))
                }
                currentCategory = bact.category
                categoryStart = index
                categoryCount = 1
            } else {
                categoryCount += 1
            }
        }
        if let cat = currentCategory {
            let midIndex = Double(categoryStart) + Double(categoryCount) / 2.0
            let angle = midIndex * sliceAngle - 90
            result.append(CategoryLabelInfo(category: cat, angle: angle))
        }

        return result
    }
}

// MARK: - Pie Slice Shape

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius,
                     startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}
