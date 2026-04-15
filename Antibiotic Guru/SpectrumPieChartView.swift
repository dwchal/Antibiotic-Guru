import SwiftUI

struct SpectrumPieChartView: View {
    let bacteria: [Bacterium]
    let coverageMap: [String: CoverageLevel]
    let highlightedBacteria: Set<String>
    let categoryFilter: BacteriaCategory?

    private let uncoveredColor = Color(red: 0.75, green: 0.78, blue: 0.82)
    private let highlightColor = Color.orange

    private var filteredBacteria: [Bacterium] {
        if let filter = categoryFilter {
            return bacteria.filter { $0.category == filter }
        }
        return bacteria
    }

    private var sliceAngle: Double {
        guard !filteredBacteria.isEmpty else { return 0 }
        return 360.0 / Double(filteredBacteria.count)
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        GeometryReader { geo in
            let isCompact = horizontalSizeClass == .compact
            // On compact, use width as the reference since it's the constraining dimension
            let size = isCompact ? geo.size.width : min(geo.size.width, geo.size.height)
            let pieRadius = size * (isCompact ? 0.24 : 0.32)
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
                        .accessibilityHidden(true)
                }

                // Draw labels outside the pie with lines
                ForEach(Array(filteredBacteria.enumerated()), id: \.element.id) { index, bacterium in
                    let startAngle = Double(index) * sliceAngle - 90
                    let midAngleDeg = startAngle + sliceAngle / 2.0
                    let midAngleRad = midAngleDeg * .pi / 180

                    // Label geometry
                    let labelRadius = pieRadius + size * (isCompact ? 0.16 : 0.18)
                    let naturalLabelX = center.x + labelRadius * cos(midAngleRad)
                    let labelY = center.y + labelRadius * sin(midAngleRad)
                    let fontSize: CGFloat = isCompact ? 9 : 11
                    let cosAngle = cos(midAngleRad)
                    let isRightSide = cosAngle > 0.2
                    let isLeftSide = cosAngle < -0.2
                    let labelWidth: CGFloat = isCompact ? size * 0.24 : size * 0.20
                    let alignment: Alignment = isRightSide ? .leading : (isLeftSide ? .trailing : .center)
                    let textAlignment: TextAlignment = isRightSide ? .leading : (isLeftSide ? .trailing : .center)

                    // Clamp labelX so the full label frame stays within the view bounds
                    let labelX: CGFloat = {
                        if isRightSide { return min(naturalLabelX, geo.size.width - labelWidth) }
                        if isLeftSide { return max(naturalLabelX, labelWidth) }
                        return naturalLabelX
                    }()
                    // Shift the frame so the anchored edge aligns with the label point
                    let adjustedX = isRightSide ? labelX + labelWidth / 2 : (isLeftSide ? labelX - labelWidth / 2 : labelX)

                    // Line from pie edge to the inner edge of the label
                    let lineStart = CGPoint(
                        x: center.x + (pieRadius + 4) * cos(midAngleRad),
                        y: center.y + (pieRadius + 4) * sin(midAngleRad)
                    )
                    let naturalLineEndX = center.x + (pieRadius + size * 0.12) * cos(midAngleRad)
                    let naturalLineEndY = center.y + (pieRadius + size * 0.12) * sin(midAngleRad)
                    let lineEndX: CGFloat = {
                        if isRightSide { return min(naturalLineEndX, labelX - 2) }
                        if isLeftSide { return max(naturalLineEndX, labelX + 2) }
                        return naturalLineEndX
                    }()
                    let lineEnd = CGPoint(x: lineEndX, y: naturalLineEndY)

                    Path { path in
                        path.move(to: lineStart)
                        path.addLine(to: lineEnd)
                    }
                    .stroke(Color.secondary.opacity(0.5), lineWidth: 1)

                    Text(bacterium.shortName)
                        .font(.system(size: fontSize, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(textAlignment)
                        .lineLimit(3)
                        .frame(width: labelWidth, alignment: alignment)
                        .position(x: adjustedX, y: labelY)
                        .accessibilityLabel("\(bacterium.name): \(sliceAccessibilityLabel(for: bacterium))")
                }

                // Category labels (outermost ring) - only on regular size
                if !isCompact {
                    ForEach(categoryLabelPositions(filteredBacteria), id: \.category.rawValue) { info in
                        let angleRad = info.angle * .pi / 180
                        let catRadius = pieRadius + size * 0.30
                        let x = center.x + catRadius * cos(angleRad)
                        let y = center.y + catRadius * sin(angleRad)

                        Text(info.category.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }

    private func sliceColor(for bacterium: Bacterium) -> Color {
        if !highlightedBacteria.isEmpty {
            return highlightedBacteria.contains(bacterium.id) ? highlightColor : uncoveredColor
        }
        guard let level = coverageMap[bacterium.id] else { return uncoveredColor }
        return level.displayColor
    }

    private func sliceAccessibilityLabel(for bacterium: Bacterium) -> String {
        if !highlightedBacteria.isEmpty {
            return highlightedBacteria.contains(bacterium.id) ? "Highlighted for selected disease" : "Not highlighted"
        }
        return coverageMap[bacterium.id]?.accessibilityLabel ?? "No coverage data"
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
