import SwiftUI

enum ChartMode: Hashable {
    case bacteria
    case fungi
}

struct FilterBarView: View {
    @Binding var categoryFilter: BacteriaCategory?
    @Binding var fungusFilter: FungusCategory?
    @Binding var showAnaerobeDetail: Bool
    let chartMode: ChartMode

    var body: some View {
        VStack(spacing: 6) {
            switch chartMode {
            case .bacteria:
                HStack(spacing: 8) {
                    bacteriaFilterButton("All", category: nil, color: .blue)
                    bacteriaFilterButton("Gram Positive", category: .gramPositive, color: .purple)
                    bacteriaFilterButton("Gram Negative", category: .gramNegative, color: .red)
                }
                HStack(spacing: 8) {
                    anaerobeDetailButton
                    bacteriaFilterButton("Atypicals", category: .atypicals, color: .green)
                }
            case .fungi:
                HStack(spacing: 8) {
                    fungusFilterButton("All Fungi", category: nil, color: .teal)
                    fungusFilterButton("Yeasts", category: .yeasts, color: .cyan)
                    fungusFilterButton("Molds", category: .molds, color: .indigo)
                }
            }
        }
        .padding(.horizontal)
    }

    private var anaerobeDetailButton: some View {
        Button {
            showAnaerobeDetail = true
        } label: {
            HStack(spacing: 4) {
                Text("Anaerobes")
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.orange)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.orange.opacity(0.15))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }

    private func bacteriaFilterButton(_ title: String, category: BacteriaCategory?, color: Color) -> some View {
        let isSelected = categoryFilter == category
        return Button {
            categoryFilter = isSelected ? nil : category
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : color.opacity(0.15))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }

    private func fungusFilterButton(_ title: String, category: FungusCategory?, color: Color) -> some View {
        let isSelected = fungusFilter == category
        return Button {
            fungusFilter = isSelected ? nil : category
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : color.opacity(0.15))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
