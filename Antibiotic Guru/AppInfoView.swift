import SwiftUI

struct AppInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showGNRExpertGuide = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Disclaimer")
                        .font(.headline)

                    Text("This app is for educational purposes only. It is not a substitute for clinical judgement.")
                        .foregroundColor(.secondary)

                    Divider()

                    Text("Data")
                        .font(.headline)

                    Text("Version \(clinicalDataMetadata.version)")
                    Text("Reviewed \(clinicalDataMetadata.lastReviewedDate)")
                    Text("Loaded: \(clinicalDataLoadStatus.isLoaded ? "Yes" : "No")")
                    Text("Source: \(clinicalDataLoadStatus.source)")
                    Text("Status: \(clinicalDataLoadStatus.message)")
                        .foregroundColor(.secondary)
                    Text(clinicalDataMetadata.sourceSummary)
                        .foregroundColor(.secondary)

                    Divider()

                    Text("Gram-Negative Resistance")
                        .font(.headline)

                    Text("ESBL, AmpC, and carbapenemase resistance patterns with treatment guidance and BL/BLI spectrum data.")
                        .foregroundColor(.secondary)

                    Button {
                        showGNRExpertGuide = true
                    } label: {
                        Label("Open Expert Guide", systemImage: "book.pages")
                    }
                    .buttonStyle(.borderedProminent)

                    Divider()

                    Text("Copyright")
                        .font(.headline)
                    Text("© \(currentYear) Antibiotic Guru")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .sheet(isPresented: $showGNRExpertGuide) {
                GramNegativeResistanceView()
            }
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
}

#Preview {
    AppInfoView()
}
