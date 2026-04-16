import Foundation

#if DEBUG
/// Validates that all antibiotic and disease data references are consistent.
/// Call once at app launch in debug builds to catch typos and missing entries.
func validateClinicalData() {
    let bacteriaIds = Set(allBacteria.map(\.id))
    let detailedAnaerobeIds = Set(allDetailedAnaerobes.map(\.id))

    // Every antibiotic must reference every bacterium ID
    for abx in allAntibiotics {
        let coveredIds = Set(abx.coverage.keys)
        let missing = bacteriaIds.subtracting(coveredIds)
        let extra = coveredIds.subtracting(bacteriaIds)
        assert(missing.isEmpty, "Antibiotic '\(abx.name)' missing coverage for: \(missing.map(\.rawValue).sorted())")
        assert(extra.isEmpty, "Antibiotic '\(abx.name)' has unknown bacterium IDs: \(extra.map(\.rawValue).sorted())")
    }

    // Every antibiotic with detailed anaerobe data must reference every detailed anaerobe ID
    for (abxId, coverage) in detailedAnaerobeCoverage {
        let coveredIds = Set(coverage.keys)
        let missing = detailedAnaerobeIds.subtracting(coveredIds)
        let extra = coveredIds.subtracting(detailedAnaerobeIds)
        assert(missing.isEmpty, "Anaerobe coverage for '\(abxId)' missing: \(missing.sorted())")
        assert(extra.isEmpty, "Anaerobe coverage for '\(abxId)' has unknown IDs: \(extra.sorted())")
    }

    // Every antibiotic should have a detailed anaerobe entry
    let abxIds = Set(allAntibiotics.map(\.id))
    let anaerobeAbxIds = Set(detailedAnaerobeCoverage.keys)
    let missingAnaerobe = abxIds.subtracting(anaerobeAbxIds)
    assert(missingAnaerobe.isEmpty, "Antibiotics missing detailed anaerobe data: \(missingAnaerobe.map(\.rawValue).sorted())")

    // Every disease must reference valid bacterium IDs
    for disease in allDiseases {
        let invalid = Set(disease.associatedBacteria).subtracting(bacteriaIds)
        assert(invalid.isEmpty, "Disease '\(disease.name)' references unknown bacteria: \(invalid.map(\.rawValue).sorted())")
    }
}
#endif
