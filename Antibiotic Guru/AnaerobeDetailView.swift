import SwiftUI

struct AnaerobeDetailView: View {
    let selectedAntibiotic: Antibiotic?
    @Environment(\.dismiss) private var dismiss

    private var coverageMap: [String: CoverageLevel] {
        guard let abx = selectedAntibiotic else { return [:] }
        return detailedAnaerobeCoverage[abx.id] ?? [:]
    }

    var body: some View {
        NavigationStack {
            List {
                if let abx = selectedAntibiotic {
                    Section {
                        Text(abx.name)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                } else {
                    Section {
                        Text("Select an antibiotic to see detailed anaerobe coverage")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                ForEach(AnaerobeSubcategory.allCases) { subcategory in
                    Section(subcategory.rawValue) {
                        ForEach(allDetailedAnaerobes.filter { $0.subcategory == subcategory }) { anaerobe in
                            anaerobeRow(anaerobe)
                        }
                    }
                }
            }
            .navigationTitle("Anaerobe Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func anaerobeRow(_ anaerobe: DetailedAnaerobe) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(coverageColor(for: anaerobe.id))
                .frame(width: 14, height: 14)
            VStack(alignment: .leading, spacing: 2) {
                Text(anaerobe.name)
                    .font(.subheadline)
                    .italic()
            }
            Spacer()
            if selectedAntibiotic != nil {
                Text(coverageLabel(for: anaerobe.id))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private func coverageColor(for anaerobeId: String) -> Color {
        guard let level = coverageMap[anaerobeId] else {
            return Color.gray.opacity(0.4)
        }
        switch level {
        case .none: return Color.gray.opacity(0.4)
        case .partial: return .yellow
        case .full: return .green
        }
    }

    private func coverageLabel(for anaerobeId: String) -> String {
        guard let level = coverageMap[anaerobeId] else { return "" }
        switch level {
        case .none: return "No coverage"
        case .partial: return "Partial"
        case .full: return "Full"
        }
    }
}
