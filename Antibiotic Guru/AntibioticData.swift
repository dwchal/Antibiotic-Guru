import Foundation

// MARK: - Models

enum CoverageLevel: Int, Codable {
    case none = 0
    case partial = 1
    case full = 2
}

enum BacteriaCategory: String, CaseIterable, Identifiable, Codable {
    case gramPositive = "Gram Positives"
    case gramNegative = "Gram Negatives"
    case anaerobes = "Anaerobes"
    case atypicals = "Atypicals"

    var id: String { rawValue }
}

enum BacteriumID: String, CaseIterable, Hashable, Codable {
    case eFaecalis
    case eFaecium
    case strepPneumo
    case strepNonPneumo
    case staphNonAureus
    case mssa
    case mrsa
    case mycoplasma
    case chlamydophila
    case legionella
    case anaerobesBelow
    case anaerobesAbove
    case pseudomonas
    case nosocomialGN
    case communityGN
}

enum AntibioticID: String, CaseIterable, Hashable, Codable {
    case amikacin
    case amoxicillin
    case amoxicillinClav
    case ampicillinSulb
    case azithromycin
    case aztreonam
    case cefazolin
    case cefepime
    case cefotaxime
    case cefotetan
    case cefoxitin
    case ceftazidime
    case ceftriaxone
    case cefuroxime
    case ciprofloxacin
    case clindamycin
    case daptomycin
    case dicloxacillin
    case doxycycline
    case ertapenem
    case erythromycin
    case gentamicin
    case imipenem
    case levofloxacin
    case linezolid
    case meropenem
    case metronidazole
    case moxifloxacin
    case nafcillin
    case nitrofurantoin
    case penicillin
    case pipTazo
    case tigecycline
    case tmpSmx
    case tobramycin
    case vancomycin
}

struct Bacterium: Identifiable, Codable {
    let id: BacteriumID
    let name: String
    let shortName: String
    let category: BacteriaCategory
}

struct Antibiotic: Identifiable, Codable {
    let id: AntibioticID
    let name: String
    let coverage: [BacteriumID: CoverageLevel]
}

struct Disease: Identifiable, Codable {
    let id: String
    let name: String
    let associatedBacteria: [BacteriumID]
}

struct ClinicalDataMetadata: Codable {
    let version: String
    let lastReviewedDate: String
    let reviewer: String
    let sourceSummary: String
}

enum AnaerobeSubcategory: String, CaseIterable, Identifiable, Codable {
    case gramNegative = "Anaerobic Gram Negatives"
    case gramPositive = "Anaerobic Gram Positives"

    var id: String { rawValue }
}

struct DetailedAnaerobe: Identifiable, Codable {
    let id: String
    let name: String
    let shortName: String
    let subcategory: AnaerobeSubcategory
}

struct ClinicalDataLoadStatus {
    let isLoaded: Bool
    let loadedAt: Date
    let source: String
    let message: String
}

struct ClinicalDataSnapshot {
    let metadata: ClinicalDataMetadata
    let bacteria: [Bacterium]
    let antibiotics: [Antibiotic]
    let diseases: [Disease]
    let detailedAnaerobes: [DetailedAnaerobe]
    let detailedAnaerobeCoverage: [AntibioticID: [String: CoverageLevel]]
    let loadStatus: ClinicalDataLoadStatus
}

let clinicalDataSnapshot = ClinicalDataLoader.load()

// Immutable, loader-backed snapshots consumed by the UI
let clinicalDataMetadata = clinicalDataSnapshot.metadata
let allBacteria = clinicalDataSnapshot.bacteria
let allAntibiotics = clinicalDataSnapshot.antibiotics
let allDiseases = clinicalDataSnapshot.diseases
let allDetailedAnaerobes = clinicalDataSnapshot.detailedAnaerobes
let detailedAnaerobeCoverage = clinicalDataSnapshot.detailedAnaerobeCoverage
let clinicalDataLoadStatus = clinicalDataSnapshot.loadStatus
