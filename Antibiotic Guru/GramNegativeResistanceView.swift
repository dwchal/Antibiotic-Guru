import SwiftUI

// MARK: - BL/BLI Activity Data

enum ActivityLevel: String {
    case active = "active"
    case variable = "variable"
    case notActive = "notActive"

    var color: Color {
        switch self {
        case .active: return .green
        case .variable: return .yellow
        case .notActive: return .red
        }
    }

    var symbol: String {
        switch self {
        case .active: return "circle.fill"
        case .variable: return "circle.lefthalf.filled"
        case .notActive: return "xmark.circle.fill"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .active: return "Active"
        case .variable: return "Variable"
        case .notActive: return "Not active"
        }
    }
}

struct BLBLIEntry: Identifiable {
    let id = UUID()
    let drug: String
    // Enterobacterales
    let esbl: ActivityLevel
    let kpc: ActivityLevel
    let cpeMBL: ActivityLevel
    let cpeOXA48: ActivityLevel
    // P. aeruginosa
    let ampCUp: ActivityLevel
    let oprDMinus: ActivityLevel
    let cpaMBL: ActivityLevel
    let cpaOXAESBL: ActivityLevel
    // A. baumannii
    let abESBL: ActivityLevel
    let cpAbMBL: ActivityLevel
    let oxa2340: ActivityLevel
}

private let blbliData: [BLBLIEntry] = [
    BLBLIEntry(drug: "CAZ-AVI", esbl: .active, kpc: .active, cpeMBL: .notActive, cpeOXA48: .active, ampCUp: .active, oprDMinus: .active, cpaMBL: .notActive, cpaOXAESBL: .active, abESBL: .notActive, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "IPM-REL", esbl: .active, kpc: .active, cpeMBL: .active, cpeOXA48: .active, ampCUp: .active, oprDMinus: .variable, cpaMBL: .active, cpaOXAESBL: .active, abESBL: .variable, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "MER-VAB", esbl: .active, kpc: .active, cpeMBL: .notActive, cpeOXA48: .notActive, ampCUp: .active, oprDMinus: .variable, cpaMBL: .notActive, cpaOXAESBL: .notActive, abESBL: .variable, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "Sul-Durlobactam", esbl: .notActive, kpc: .active, cpeMBL: .notActive, cpeOXA48: .active, ampCUp: .notActive, oprDMinus: .notActive, cpaMBL: .notActive, cpaOXAESBL: .notActive, abESBL: .active, cpAbMBL: .active, oxa2340: .active),
    BLBLIEntry(drug: "ATM-AVI", esbl: .active, kpc: .active, cpeMBL: .active, cpeOXA48: .active, ampCUp: .active, oprDMinus: .active, cpaMBL: .active, cpaOXAESBL: .variable, abESBL: .notActive, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "FEP-Zidebactam", esbl: .active, kpc: .active, cpeMBL: .active, cpeOXA48: .active, ampCUp: .active, oprDMinus: .active, cpaMBL: .active, cpaOXAESBL: .active, abESBL: .variable, cpAbMBL: .variable, oxa2340: .variable),
    BLBLIEntry(drug: "MER-Nacubactam", esbl: .active, kpc: .active, cpeMBL: .active, cpeOXA48: .active, ampCUp: .active, oprDMinus: .variable, cpaMBL: .notActive, cpaOXAESBL: .notActive, abESBL: .notActive, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "FEP-Taniborbactam", esbl: .active, kpc: .active, cpeMBL: .active, cpeOXA48: .active, ampCUp: .active, oprDMinus: .active, cpaMBL: .active, cpaOXAESBL: .variable, abESBL: .notActive, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "FEP-Enmetazobactam", esbl: .active, kpc: .variable, cpeMBL: .notActive, cpeOXA48: .variable, ampCUp: .notActive, oprDMinus: .notActive, cpaMBL: .notActive, cpaOXAESBL: .notActive, abESBL: .notActive, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "CTB-Ledaborbactam", esbl: .active, kpc: .active, cpeMBL: .notActive, cpeOXA48: .active, ampCUp: .notActive, oprDMinus: .notActive, cpaMBL: .notActive, cpaOXAESBL: .notActive, abESBL: .notActive, cpAbMBL: .notActive, oxa2340: .notActive),
    BLBLIEntry(drug: "MER-Xerurorbactam", esbl: .active, kpc: .active, cpeMBL: .active, cpeOXA48: .active, ampCUp: .variable, oprDMinus: .active, cpaMBL: .active, cpaOXAESBL: .active, abESBL: .active, cpAbMBL: .active, oxa2340: .active),
    BLBLIEntry(drug: "Cefiderocol", esbl: .active, kpc: .active, cpeMBL: .active, cpeOXA48: .active, ampCUp: .variable, oprDMinus: .variable, cpaMBL: .variable, cpaOXAESBL: .variable, abESBL: .variable, cpAbMBL: .variable, oxa2340: .variable),
]

// MARK: - Main View

struct GramNegativeResistanceView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                esblSection
                ampCSection
                carbapenemaseSection
                blbliSpectrumSection
                disclaimerSection
            }
            .navigationTitle("GNR Expert Guide")
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

    // MARK: - ESBL Section

    private var esblSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Extended Spectrum Beta-lactamase (ESBL)")
                    .font(.headline)

                Text("Any gram negative can harbor ESBL genes, but most common in:")
                    .font(.subheadline)
                Text("E. coli, K. pneumoniae, K. oxytoca, P. mirabilis")
                    .italic()
                    .font(.subheadline)

                bulletList([
                    "Mobile genetic elements (>900 types)",
                    "Inhibitor-susceptible \u{03B2}-lactamases",
                    "Most common: CTX-M, SHV, TEM families",
                    "Resistance to penicillins, 1st\u{2013}3rd gen cephalosporins, sometimes 4th gen cephalosporins, aztreonam",
                ])
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Predicting ESBL Presence")
                    .font(.subheadline.weight(.semibold))

                Text("When the lab doesn\u{2019}t do phenotypic testing, ceftriaxone MIC \u{2265} 2 mcg/mL is a proxy for ESBL production by E. coli, K. pneumoniae, K. oxytoca, or P. mirabilis.")
                    .font(.subheadline)

                Text("This approach is sensitive but not specific:")
                    .font(.subheadline.weight(.medium))

                bulletList([
                    "All E. coli, Klebsiella, and P. mirabilis with ESBL have ceftriaxone MIC \u{2265} 2 mcg/mL",
                    "NOT ALL with elevated ceftriaxone MIC have ESBL \u{2014} some harbor plasmid-mediated ampC genes or may lack a beta-lactamase entirely",
                    "One study: 87% ESBL, 7% ampC, 6% narrow-spectrum \u{03B2}-lactamase (Spafford et al., JCM 2019)",
                    "Some argue this method is inadequate and overpromotes carbapenem use (Tamma et al., JAC 2021)",
                ])
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("ESBL Treatment Options")
                    .font(.subheadline.weight(.semibold))

                treatmentRow(label: "Uncomplicated cystitis", detail: "Nitrofurantoin, TMP-SMX")
                treatmentRow(label: "Pyelonephritis", detail: "Ertapenem, meropenem, imipenem-cilastatin, ciprofloxacin, levofloxacin, or TMP-SMX")
                treatmentRow(label: "Non-urinary infection", detail: "Carbapenem (may consider oral step-down to TMP-SMX or fluoroquinolone)")

                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.subheadline)
                    Text("Piperacillin-tazobactam and cefepime should be avoided for ESBL-E infections, even if susceptible.")
                        .font(.subheadline.weight(.medium))
                }
            }
        } header: {
            Text("ESBL")
        }
    }

    // MARK: - AmpC Section

    private var ampCSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Class C Serine Beta-lactamase (AmpC)")
                    .font(.headline)

                Text("Highest risk Enterobacterales:")
                    .font(.subheadline.weight(.medium))
                Text("Enterobacter cloacae, Klebsiella aerogenes, Citrobacter freundii")
                    .italic()
                    .font(.subheadline)
                Text("If isolated in a non-urine specimen, do NOT use ceftriaxone empiric therapy.")
                    .font(.subheadline)
                    .foregroundColor(.red)

                Text("Traditionally thought high risk (SPICE organisms):")
                    .font(.subheadline.weight(.medium))
                Text("Serratia marcescens, Morganella morganii, Providencia spp. \u{2014} risk has been overstated (<5%); trust susceptibility results.")
                    .font(.subheadline)

                Text("Note: C. freundii has a chromosomal ampC; C. koseri does not.")
                    .font(.subheadline)
                    .italic()

                bulletList([
                    "Inducible chromosomal resistance \u{2014} can emerge after a few doses of ceftriaxone/ceftazidime",
                    "Stable chromosomal de-repression",
                    "Plasmid-mediated genes \u{2014} most seen in E. coli, K. pneumoniae, Salmonella spp.",
                ])
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("AmpC Treatment Considerations")
                    .font(.subheadline.weight(.semibold))

                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.subheadline)
                    Text("Ceftriaxone: should NOT be used (except sometimes for simple cystitis if susceptible).")
                        .font(.subheadline)
                }

                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.subheadline)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Piperacillin-tazobactam:")
                            .font(.subheadline.weight(.medium))
                        Text("Tazobactam is less effective against AmpC. Observational data show increased mortality in serious AmpC infections treated with pip-tazo.")
                            .font(.subheadline)
                    }
                }

                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.subheadline)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cefepime:")
                            .font(.subheadline.weight(.medium))
                        Text("Weak inducer of AmpC and withstands hydrolysis. Good option when MIC \u{2264} 2 mcg/mL.")
                            .font(.subheadline)
                    }
                }

                bulletList([
                    "If cefepime MIC \u{2265} 4 mcg/mL: high (90%) likelihood of concurrent ESBL \u{2014} use a carbapenem",
                    "Ceftazidime resistance does NOT rule out cefepime use (expected with AmpC expression)",
                    "New \u{03B2}-lactam/BLI combos (e.g., cefiderocol): potent but reserve for concurrent carbapenemase",
                    "TMP-SMX / fluoroquinolones: IV or oral step-down options",
                    "Uncomplicated cystitis: nitrofurantoin, TMP-SMX, or single-dose aminoglycoside",
                ])
            }
        } header: {
            Text("AmpC")
        }
    }

    // MARK: - Carbapenemase Section

    private var carbapenemaseSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Carbapenemases")
                    .font(.headline)

                bulletList([
                    "Mobile genetic elements conferring resistance to most/all beta-lactams",
                    "In the USA, most common is KPC (Klebsiella pneumoniae carbapenemase)",
                    "Metallo-beta-lactamases: NDM, IMP, VIM",
                    "Oxacillinases (OXA): may be susceptible to cephalosporins but not carbapenems",
                ])
            }
        } header: {
            Text("Carbapenemases")
        }
    }

    // MARK: - BL/BLI Spectrum Table

    private var blbliSpectrumSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("BL/BLI Combination Spectrum")
                    .font(.headline)

                Text("Source: ESCMID Global")
                    .font(.caption)
                    .foregroundColor(.secondary)

                legendRow
            }

            ForEach(blbliData) { entry in
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.drug)
                        .font(.subheadline.weight(.semibold))

                    activityGrid(for: entry)
                }
                .padding(.vertical, 2)
            }
        } header: {
            Text("\u{03B2}-Lactam/BLI Spectrum")
        }
    }

    private var legendRow: some View {
        HStack(spacing: 16) {
            legendItem(.active, label: "Active")
            legendItem(.variable, label: "Variable")
            legendItem(.notActive, label: "Not active")
        }
        .font(.caption)
    }

    private func legendItem(_ level: ActivityLevel, label: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: level.symbol)
                .foregroundColor(level.color)
            Text(label)
        }
    }

    private func activityGrid(for entry: BLBLIEntry) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Enterobacterales")
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
            HStack(spacing: 8) {
                activityCell("ESBL", entry.esbl)
                activityCell("KPC", entry.kpc)
                activityCell("MBL", entry.cpeMBL)
                activityCell("OXA-48", entry.cpeOXA48)
            }

            Text("P. aeruginosa")
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
            HStack(spacing: 8) {
                activityCell("AmpC\u{2191}", entry.ampCUp)
                activityCell("OprD-", entry.oprDMinus)
                activityCell("MBL", entry.cpaMBL)
                activityCell("OXA/ESBL", entry.cpaOXAESBL)
            }

            Text("A. baumannii")
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
            HStack(spacing: 8) {
                activityCell("ESBL", entry.abESBL)
                activityCell("MBL", entry.cpAbMBL)
                activityCell("OXA-23/40", entry.oxa2340)
            }
        }
        .font(.caption)
    }

    private func activityCell(_ label: String, _ level: ActivityLevel) -> some View {
        HStack(spacing: 2) {
            Image(systemName: level.symbol)
                .foregroundColor(level.color)
                .font(.caption2)
            Text(label)
                .font(.caption2)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(level.accessibilityLabel)")
    }

    // MARK: - Disclaimer

    private var disclaimerSection: some View {
        Section {
            Text("Clinical notes are educational summaries. Interpret with local susceptibility data, organism identification, and syndrome-specific guidance. Jacoby, CMR 2009 is a key reference for AmpC.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Helpers

    private func bulletList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 6) {
                    Text("\u{2022}")
                        .font(.subheadline)
                    Text(item)
                        .font(.subheadline)
                }
            }
        }
    }

    private func treatmentRow(label: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.subheadline.weight(.medium))
            Text(detail)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    GramNegativeResistanceView()
}
