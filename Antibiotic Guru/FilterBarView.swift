import SwiftUI

struct FilterBarView: View {
    @Binding var categoryFilter: BacteriaCategory?
    @Binding var showAnaerobeDetail: Bool

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                filterButton("All", category: nil, color: .blue)
                filterButton("Gram Positive", category: .gramPositive, color: .purple)
                filterButton("Gram Negative", category: .gramNegative, color: .red)
            }
            HStack(spacing: 8) {
                anaerobeDetailButton
                filterButton("Atypicals", category: .atypicals, color: .green)
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

    private func filterButton(_ title: String, category: BacteriaCategory?, color: Color) -> some View {
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
}
