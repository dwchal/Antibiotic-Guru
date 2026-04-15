import Foundation

// MARK: - Models

enum CoverageLevel: Int {
    case none = 0
    case partial = 1
    case full = 2
}

enum BacteriaCategory: String, CaseIterable, Identifiable {
    case gramPositive = "Gram Positives"
    case gramNegative = "Gram Negatives"
    case anaerobes = "Anaerobes"
    case atypicals = "Atypicals"

    var id: String { rawValue }
}

struct Bacterium: Identifiable {
    let id: String
    let name: String
    let shortName: String
    let category: BacteriaCategory
}

struct Antibiotic: Identifiable {
    let id: String
    let name: String
    let coverage: [String: CoverageLevel]
}

struct Disease: Identifiable {
    let id: String
    let name: String
    let associatedBacteria: [String]
}

// MARK: - Bacteria Data

let allBacteria: [Bacterium] = [
    // Gram Positives (clockwise from top)
    Bacterium(id: "enterococcus", name: "Enterococcus", shortName: "Enterococcus", category: .gramPositive),
    Bacterium(id: "strepPneumo", name: "Streptococcus pneumoniae", shortName: "S. pneumoniae", category: .gramPositive),
    Bacterium(id: "strepNonPneumo", name: "Streptococcus (non-pneumoniae)", shortName: "Strep (non-pneumo)", category: .gramPositive),
    Bacterium(id: "staphNonAureus", name: "Staphylococcus (non-aureus)", shortName: "Staph (non-aureus)", category: .gramPositive),
    Bacterium(id: "mssa", name: "Staphylococcus aureus (MSSA)", shortName: "S. aureus (MSSA)", category: .gramPositive),
    Bacterium(id: "mrsa", name: "Staphylococcus aureus (MRSA)", shortName: "S. aureus (MRSA)", category: .gramPositive),

    // Atypicals
    Bacterium(id: "mycoplasma", name: "Mycoplasma pneumoniae", shortName: "M. pneumoniae", category: .atypicals),
    Bacterium(id: "chlamydophila", name: "Chlamydophila", shortName: "Chlamydophila", category: .atypicals),
    Bacterium(id: "legionella", name: "Legionella", shortName: "Legionella", category: .atypicals),

    // Anaerobes
    Bacterium(id: "anaerobesBelow", name: "Anaerobes Below the Diaphragm", shortName: "Anaerobes\nBelow Diaphragm", category: .anaerobes),
    Bacterium(id: "anaerobesAbove", name: "Anaerobes Above the Diaphragm", shortName: "Anaerobes\nAbove Diaphragm", category: .anaerobes),

    // Gram Negatives
    Bacterium(id: "pseudomonas", name: "Pseudomonas aeruginosa", shortName: "P. aeruginosa", category: .gramNegative),
    Bacterium(id: "nosocomialGN", name: "Nosocomial Acquired Gram Neg.", shortName: "Nosocomial\nGram Neg.", category: .gramNegative),
    Bacterium(id: "communityGN", name: "Community Acquired Gram Neg.", shortName: "Community\nGram Neg.", category: .gramNegative),
]

// MARK: - Antibiotic Coverage Data

// Coverage helper: creates a dictionary from an array of (bacteriumId, coverageLevel) pairs
private func cov(_ pairs: [(String, CoverageLevel)]) -> [String: CoverageLevel] {
    Dictionary(uniqueKeysWithValues: pairs)
}

let allAntibiotics: [Antibiotic] = [
    Antibiotic(id: "amikacin", name: "Amikacin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "amoxicillin", name: "Amoxicillin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .full),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "amoxicillinClav", name: "Amoxicillin Clavulanate", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .partial),
        ("communityGN", .full), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ampicillinSulb", name: "Ampicillin Sulbactam", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .full),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "azithromycin", name: "Azithromycin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .none),
        ("strepNonPneumo", .partial), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "aztreonam", name: "Aztreonam", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefazolin", name: "Cefazolin", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .partial), ("enterococcus", .none),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefepime", name: "Cefepime", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefotaxime", name: "Cefotaxime", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefotetan", name: "Cefotetan", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefoxitin", name: "Cefoxitin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ceftazidime", name: "Ceftazidime", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ceftriaxone", name: "Ceftriaxone", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefuroxime", name: "Cefuroxime", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ciprofloxacin", name: "Ciprofloxacin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .partial), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "clindamycin", name: "Clindamycin", coverage: cov([
        ("mrsa", .partial), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .partial),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "daptomycin", name: "Daptomycin", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .full),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "dicloxacillin", name: "Dicloxacillin", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .partial), ("enterococcus", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "doxycycline", name: "Doxycycline", coverage: cov([
        ("mrsa", .partial), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("enterococcus", .none),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .partial)
    ])),
    Antibiotic(id: "ertapenem", name: "Ertapenem", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "erythromycin", name: "Erythromycin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "gentamicin", name: "Gentamicin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .partial),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "imipenem", name: "Imipenem", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .full),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "levofloxacin", name: "Levofloxacin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "linezolid", name: "Linezolid", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .full),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "meropenem", name: "Meropenem", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .partial),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "metronidazole", name: "Metronidazole", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("enterococcus", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "moxifloxacin", name: "Moxifloxacin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .partial),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "nafcillin", name: "Nafcillin", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .partial), ("enterococcus", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "nitrofurantoin", name: "Nitrofurantoin", coverage: cov([
        ("mrsa", .partial), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .none), ("enterococcus", .full),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "penicillin", name: "Penicillin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .partial),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "pipTazo", name: "Piperacillin Tazobactam", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .full),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "tigecycline", name: "Tigecycline", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .partial),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .partial), ("chlamydophila", .partial), ("legionella", .none)
    ])),
    Antibiotic(id: "tmpSmx", name: "TMP-SMX", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .partial), ("strepPneumo", .full), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "tobramycin", name: "Tobramycin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("enterococcus", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "vancomycin", name: "Vancomycin", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("enterococcus", .full),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
]

// MARK: - Disease Data

let allDiseases: [Disease] = [
    Disease(id: "animalBites", name: "Animal Bites",
            associatedBacteria: ["communityGN", "anaerobesAbove", "strepNonPneumo"]),
    Disease(id: "cellulitis", name: "Cellulitis",
            associatedBacteria: ["mssa", "mrsa", "strepNonPneumo"]),
    Disease(id: "cap", name: "Community Acquired Pneumonia",
            associatedBacteria: ["strepPneumo", "communityGN", "mycoplasma", "chlamydophila", "legionella"]),
    Disease(id: "meningitis", name: "Meningitis",
            associatedBacteria: ["strepPneumo", "communityGN"]),
    Disease(id: "nosocomialPneumonia", name: "Nosocomial Pneumonia",
            associatedBacteria: ["nosocomialGN", "pseudomonas", "mrsa"]),
    Disease(id: "uti", name: "Urinary Tract Infection",
            associatedBacteria: ["communityGN", "enterococcus"]),
    Disease(id: "vap", name: "Ventilator Acquired Pneumonia",
            associatedBacteria: ["pseudomonas", "nosocomialGN", "mrsa"]),
    Disease(id: "sepsis", name: "Sepsis - The 5 Killers",
            associatedBacteria: ["strepPneumo", "communityGN", "mssa", "mrsa", "pseudomonas"]),
]
