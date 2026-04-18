import SwiftUI

struct AntifungalsSidebarView: View {
    let antifungals: [Antifungal]
    @Binding var selectedAntifungal: Antifungal?
    @Binding var searchText: String
    let onSelect: (Antifungal) -> Void

    private var filteredAntifungals: [Antifungal] {
        guard !searchText.isEmpty else { return antifungals }
        return antifungals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Antifungals")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            TextField("Search antifungals", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 12)
                .padding(.bottom, 6)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredAntifungals) { af in
                        antifungalRow(af)
                        Divider().padding(.leading, 12)
                    }
                }
            }
        }
    }

    private func antifungalRow(_ af: Antifungal) -> some View {
        Button {
            onSelect(af)
        } label: {
            Text(af.name)
                .font(.system(size: 14))
                .foregroundColor(selectedAntifungal?.id == af.id ? .white : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    selectedAntifungal?.id == af.id ? Color.teal : Color.clear
                )
        }
        .buttonStyle(.plain)
    }
}
