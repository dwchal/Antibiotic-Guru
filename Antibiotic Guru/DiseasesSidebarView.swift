import SwiftUI

struct DiseasesSidebarView: View {
    let diseases: [Disease]
    let bacteria: [Bacterium]
    let coverageMap: [String: CoverageLevel]
    let highlightedBacteria: Set<String>
    @Binding var selectedDisease: Disease?
    @Binding var searchText: String
    let onSelect: (Disease) -> Void

    private var filteredDiseases: [Disease] {
        guard !searchText.isEmpty else { return diseases }
        return diseases.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var groupedBacteria: [(category: BacteriaCategory, bacteria: [Bacterium])] {
        BacteriaCategory.allCases.map { category in
            (category, bacteria.filter { $0.category == category })
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Diseases")
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)

                    TextField("Search diseases", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 6)

                    ForEach(filteredDiseases) { disease in
                        diseaseRow(disease)
                    }
                }

                Divider()

                bacteriaGroupsList
            }
            .padding(.vertical, 8)
        }
    }

    private func diseaseRow(_ disease: Disease) -> some View {
        Button {
            onSelect(disease)
        } label: {
            Text(disease.name)
                .font(.system(size: 13))
                .foregroundColor(selectedDisease?.id == disease.id ? .white : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    selectedDisease?.id == disease.id ? Color.orange : Color.clear
                )
        }
        .buttonStyle(.plain)
    }

    private var bacteriaGroupsList: some View {
        ForEach(groupedBacteria, id: \.category) { group in
            VStack(alignment: .leading, spacing: 2) {
                Text(group.category.rawValue)
                    .font(.subheadline.bold())
                    .padding(.horizontal, 12)

                ForEach(group.bacteria) { bact in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(bacteriaIndicatorColor(for: bact))
                            .frame(width: 10, height: 10)
                        Text(bact.name)
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 1)
                }
            }
            .padding(.bottom, 4)
        }
    }

    private func bacteriaIndicatorColor(for bacterium: Bacterium) -> Color {
        if !highlightedBacteria.isEmpty {
            return highlightedBacteria.contains(bacterium.id) ? .orange : Color.gray.opacity(0.4)
        }
        return coverageMap[bacterium.id]?.displayColor ?? Color.gray.opacity(0.4)
    }
}
