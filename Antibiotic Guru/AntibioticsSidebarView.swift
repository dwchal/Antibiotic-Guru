import SwiftUI

struct AntibioticsSidebarView: View {
    let antibiotics: [Antibiotic]
    @Binding var selectedAntibiotic: Antibiotic?
    @Binding var searchText: String
    let onSelect: (Antibiotic) -> Void

    private var filteredAntibiotics: [Antibiotic] {
        guard !searchText.isEmpty else { return antibiotics }
        return antibiotics.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Antibiotics")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            TextField("Search antibiotics", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 12)
                .padding(.bottom, 6)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredAntibiotics) { abx in
                        antibioticRow(abx)
                        Divider().padding(.leading, 12)
                    }
                }
            }
        }
    }

    private func antibioticRow(_ abx: Antibiotic) -> some View {
        Button {
            onSelect(abx)
        } label: {
            Text(abx.name)
                .font(.system(size: 14))
                .foregroundColor(selectedAntibiotic?.id == abx.id ? .white : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    selectedAntibiotic?.id == abx.id ? Color.blue : Color.clear
                )
        }
        .buttonStyle(.plain)
    }
}
