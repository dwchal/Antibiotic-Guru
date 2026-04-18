import Foundation

// MARK: - Models

enum CoverageLevel: String, Codable {
    case none
    case partial
    case full
}

enum BacteriaCategory: String, CaseIterable, Identifiable, Codable {
    case gramPositive
    case gramNegative
    case anaerobes
    case atypicals

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .gramPositive: "Gram Positives"
        case .gramNegative: "Gram Negatives"
        case .anaerobes: "Anaerobes"
        case .atypicals: "Atypicals"
        }
    }
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

    private enum CodingKeys: String, CodingKey {
        case id, name, coverage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(AntibioticID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let raw = try container.decode([String: CoverageLevel].self, forKey: .coverage)
        coverage = try raw.reduce(into: [:]) { result, pair in
            guard let key = BacteriumID(rawValue: pair.key) else {
                throw DecodingError.dataCorruptedError(forKey: .coverage, in: container, debugDescription: "Unknown bacterium ID: \(pair.key)")
            }
            result[key] = pair.value
        }
    }
}

struct Disease: Identifiable, Codable {
    let id: String
    let name: String
    let associatedBacteria: [BacteriumID]
    let associatedFungi: [FungusID]

    private enum CodingKeys: String, CodingKey {
        case id, name, associatedBacteria, associatedFungi
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        associatedBacteria = try container.decodeIfPresent([BacteriumID].self, forKey: .associatedBacteria) ?? []
        associatedFungi = try container.decodeIfPresent([FungusID].self, forKey: .associatedFungi) ?? []
    }
}

// MARK: - Fungal Models

enum FungusCategory: String, CaseIterable, Identifiable, Codable {
    case yeasts
    case molds

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .yeasts: "Yeasts"
        case .molds: "Molds"
        }
    }
}

enum FungusID: String, CaseIterable, Hashable, Codable {
    case candidaAlbicans
    case candidaGlabrata
    case candidaKrusei
    case candidaParapsilosis
    case candidaAuris
    case aspergillus
    case cryptococcus
    case mucorales
    case pneumocystis
}

struct Fungus: Identifiable, Codable {
    let id: FungusID
    let name: String
    let shortName: String
    let category: FungusCategory
}

enum AntifungalID: String, CaseIterable, Hashable, Codable {
    case fluconazole
    case voriconazole
    case posaconazole
    case isavuconazole
    case caspofungin
    case micafungin
    case anidulafungin
    case amphotericinB
}

struct Antifungal: Identifiable, Codable {
    let id: AntifungalID
    let name: String
    let coverage: [FungusID: CoverageLevel]

    private enum CodingKeys: String, CodingKey {
        case id, name, coverage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(AntifungalID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let raw = try container.decode([String: CoverageLevel].self, forKey: .coverage)
        coverage = try raw.reduce(into: [:]) { result, pair in
            guard let key = FungusID(rawValue: pair.key) else {
                throw DecodingError.dataCorruptedError(forKey: .coverage, in: container, debugDescription: "Unknown fungus ID: \(pair.key)")
            }
            result[key] = pair.value
        }
    }
}

struct ClinicalDataMetadata: Codable {
    let version: String
    let lastReviewedDate: String
    let reviewer: String
    let sourceSummary: String
}

enum AnaerobeSubcategory: String, CaseIterable, Identifiable, Codable {
    case gramNegative
    case gramPositive

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .gramNegative: "Anaerobic Gram Negatives"
        case .gramPositive: "Anaerobic Gram Positives"
        }
    }
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
    let fungi: [Fungus]
    let antifungals: [Antifungal]
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
let allFungi = clinicalDataSnapshot.fungi
let allAntifungals = clinicalDataSnapshot.antifungals
let clinicalDataLoadStatus = clinicalDataSnapshot.loadStatus
