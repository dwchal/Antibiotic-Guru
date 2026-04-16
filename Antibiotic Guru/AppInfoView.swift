import SwiftUI

struct AppInfoView: View {
    @Environment(\.dismiss) private var dismiss

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
                    Text(clinicalDataMetadata.sourceSummary)
                        .foregroundColor(.secondary)

                    Divider()

                    Text("Copyright")
                        .font(.headline)
                    Text("© \(currentYear) Antibiotic Guru")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
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
