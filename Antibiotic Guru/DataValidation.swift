import Foundation

#if DEBUG
/// Validates decoded clinical data schema and cross-reference completeness.
/// Called once at app launch to fail fast on bad bundled data.
func validateClinicalData() {
    func fail(_ message: String) -> Never {
        preconditionFailure("Clinical data validation failed: \(message)")
    }

    if allBacteria.isEmpty { fail("Bacteria dataset is empty") }
    if allAntibiotics.isEmpty { fail("Antibiotics dataset is empty") }
    if allDiseases.isEmpty { fail("Diseases dataset is empty") }
    if allDetailedAnaerobes.isEmpty { fail("Detailed anaerobes dataset is empty") }

    let bacteriaIds = Set(allBacteria.map(\.id))
    let expectedBacteriaIds = Set(BacteriumID.allCases)
    if bacteriaIds != expectedBacteriaIds {
        fail("Bacteria IDs mismatch. Missing: \(expectedBacteriaIds.subtracting(bacteriaIds).map(\.rawValue).sorted()) extra: \(bacteriaIds.subtracting(expectedBacteriaIds).map(\.rawValue).sorted())")
    }

    let antibioticIds = Set(allAntibiotics.map(\.id))
    let expectedAntibioticIds = Set(AntibioticID.allCases)
    if antibioticIds != expectedAntibioticIds {
        fail("Antibiotic IDs mismatch. Missing: \(expectedAntibioticIds.subtracting(antibioticIds).map(\.rawValue).sorted()) extra: \(antibioticIds.subtracting(expectedAntibioticIds).map(\.rawValue).sorted())")
    }

    let detailedAnaerobeIds = Set(allDetailedAnaerobes.map(\.id))

    for abx in allAntibiotics {
        let coveredIds = Set(abx.coverage.keys)
        let missing = bacteriaIds.subtracting(coveredIds)
        let extra = coveredIds.subtracting(bacteriaIds)
        if !missing.isEmpty {
            fail("Antibiotic '\(abx.name)' missing coverage for: \(missing.map(\.rawValue).sorted())")
        }
        if !extra.isEmpty {
            fail("Antibiotic '\(abx.name)' has unknown bacterium IDs: \(extra.map(\.rawValue).sorted())")
        }
    }

    let anaerobeCoverageIds = Set(detailedAnaerobeCoverage.keys)
    let missingAnaerobeCoverage = antibioticIds.subtracting(anaerobeCoverageIds)
    if !missingAnaerobeCoverage.isEmpty {
        fail("Antibiotics missing detailed anaerobe data: \(missingAnaerobeCoverage.map(\.rawValue).sorted())")
    }

    for (abxId, coverage) in detailedAnaerobeCoverage {
        let coveredIds = Set(coverage.keys)
        let missing = detailedAnaerobeIds.subtracting(coveredIds)
        let extra = coveredIds.subtracting(detailedAnaerobeIds)
        if !missing.isEmpty {
            fail("Anaerobe coverage for '\(abxId.rawValue)' missing: \(missing.sorted())")
        }
        if !extra.isEmpty {
            fail("Anaerobe coverage for '\(abxId.rawValue)' has unknown IDs: \(extra.sorted())")
        }
    }

    for disease in allDiseases {
        if disease.associatedBacteria.isEmpty {
            fail("Disease '\(disease.name)' has no associated bacteria")
        }
        let invalid = Set(disease.associatedBacteria).subtracting(bacteriaIds)
        if !invalid.isEmpty {
            fail("Disease '\(disease.name)' references unknown bacteria: \(invalid.map(\.rawValue).sorted())")
        }
    }
}
#endif
