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
    if allFungi.isEmpty { fail("Fungi dataset is empty") }
    if allAntifungals.isEmpty { fail("Antifungals dataset is empty") }

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

    let fungusIds = Set(allFungi.map(\.id))
    let expectedFungusIds = Set(FungusID.allCases)
    if fungusIds != expectedFungusIds {
        fail("Fungus IDs mismatch. Missing: \(expectedFungusIds.subtracting(fungusIds).map(\.rawValue).sorted()) extra: \(fungusIds.subtracting(expectedFungusIds).map(\.rawValue).sorted())")
    }

    let antifungalIds = Set(allAntifungals.map(\.id))
    let expectedAntifungalIds = Set(AntifungalID.allCases)
    if antifungalIds != expectedAntifungalIds {
        fail("Antifungal IDs mismatch. Missing: \(expectedAntifungalIds.subtracting(antifungalIds).map(\.rawValue).sorted()) extra: \(antifungalIds.subtracting(expectedAntifungalIds).map(\.rawValue).sorted())")
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

    for af in allAntifungals {
        let coveredIds = Set(af.coverage.keys)
        let missing = fungusIds.subtracting(coveredIds)
        let extra = coveredIds.subtracting(fungusIds)
        if !missing.isEmpty {
            fail("Antifungal '\(af.name)' missing coverage for: \(missing.map(\.rawValue).sorted())")
        }
        if !extra.isEmpty {
            fail("Antifungal '\(af.name)' has unknown fungus IDs: \(extra.map(\.rawValue).sorted())")
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
        if disease.associatedBacteria.isEmpty && disease.associatedFungi.isEmpty {
            fail("Disease '\(disease.name)' has no associated bacteria or fungi")
        }
        let invalidBacteria = Set(disease.associatedBacteria).subtracting(bacteriaIds)
        if !invalidBacteria.isEmpty {
            fail("Disease '\(disease.name)' references unknown bacteria: \(invalidBacteria.map(\.rawValue).sorted())")
        }
        let invalidFungi = Set(disease.associatedFungi).subtracting(fungusIds)
        if !invalidFungi.isEmpty {
            fail("Disease '\(disease.name)' references unknown fungi: \(invalidFungi.map(\.rawValue).sorted())")
        }
    }
}
#endif
