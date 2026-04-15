import SwiftUI

extension CoverageLevel {
    var displayLabel: String {
        switch self {
        case .none: return "No coverage"
        case .partial: return "Partial coverage"
        case .full: return "Full coverage"
        }
    }

    var displayColor: Color {
        switch self {
        case .none: return Color.gray.opacity(0.4)
        case .partial: return .yellow
        case .full: return .green
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .none: return "No activity"
        case .partial: return "Partial activity"
        case .full: return "Good activity"
        }
    }
}
