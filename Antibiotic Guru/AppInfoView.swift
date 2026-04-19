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
                    Text("Loaded: \(clinicalDataLoadStatus.isLoaded ? "Yes" : "No")")
                    Text("Source: \(clinicalDataLoadStatus.source)")
                    Text("Status: \(clinicalDataLoadStatus.message)")
                        .foregroundColor(.secondary)
                    Text(clinicalDataMetadata.sourceSummary)
                        .foregroundColor(.secondary)

                    Divider()

                    Text("Gram-Negative Resistance (AST Quick Guide)")
                        .font(.headline)

                    Group {
                        Text("ESBL")
                            .font(.subheadline.weight(.semibold))
                        Text("Common hosts: E. coli, K. pneumoniae, K. oxytoca, and P. mirabilis.")
                        Text("When phenotypic testing is unavailable, ceftriaxone MIC ≥ 2 mcg/mL can be used as a sensitive but non-specific proxy in E. coli / Klebsiella / P. mirabilis.")
                        Text("Avoid piperacillin-tazobactam and cefepime for serious ESBL infections, even if reported susceptible.")
                    }
                    .foregroundColor(.secondary)

                    Group {
                        Text("AmpC")
                            .font(.subheadline.weight(.semibold))
                        Text("Highest-risk Enterobacterales: Enterobacter cloacae, Klebsiella aerogenes, and Citrobacter freundii.")
                        Text("Avoid ceftriaxone for invasive infections from high-risk AmpC producers; cefepime is often preferred when susceptible.")
                        Text("A cefepime MIC ≥ 4 mcg/mL may indicate concurrent ESBL and should prompt carbapenem consideration.")
                    }
                    .foregroundColor(.secondary)

                    Group {
                        Text("Carbapenemases")
                            .font(.subheadline.weight(.semibold))
                        Text("Often plasmid-mediated and can confer resistance to most beta-lactams.")
                        Text("In the United States, KPC remains the most common carbapenemase; MBLs (NDM, IMP, VIM) and OXA variants are also clinically important.")
                    }
                    .foregroundColor(.secondary)

                    Text("Clinical notes are educational summaries and should be interpreted with local susceptibility data, organism identification, and syndrome-specific guidance.")
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
