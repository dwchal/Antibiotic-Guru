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
    Bacterium(id: "eFaecalis", name: "Enterococcus faecalis", shortName: "E. faecalis", category: .gramPositive),
    Bacterium(id: "eFaecium", name: "Enterococcus faecium", shortName: "E. faecium", category: .gramPositive),
    Bacterium(id: "strepPneumo", name: "Streptococcus pneumoniae", shortName: "S. pneumoniae", category: .gramPositive),
    Bacterium(id: "strepNonPneumo", name: "Streptococcus (non-pneumoniae)", shortName: "Strep (non-pneumo)", category: .gramPositive),
    Bacterium(id: "staphNonAureus", name: "Coagulase negative Staphylococci", shortName: "CoNS", category: .gramPositive),
    Bacterium(id: "mssa", name: "Staphylococcus aureus (MSSA)", shortName: "S. aureus (MSSA)", category: .gramPositive),
    Bacterium(id: "mrsa", name: "Staphylococcus aureus (MRSA)", shortName: "S. aureus (MRSA)", category: .gramPositive),

    // Atypicals
    Bacterium(id: "mycoplasma", name: "Mycoplasma pneumoniae", shortName: "M. pneumoniae", category: .atypicals),
    Bacterium(id: "chlamydophila", name: "Chlamydia pneumoniae", shortName: "C. pneumoniae", category: .atypicals),
    Bacterium(id: "legionella", name: "Legionella", shortName: "Legionella", category: .atypicals),

    // Anaerobes
    Bacterium(id: "anaerobesBelow", name: "Anaerobes Below the Diaphragm", shortName: "Anaerobes\nBelow Diaphragm", category: .anaerobes),
    Bacterium(id: "anaerobesAbove", name: "Anaerobes Above the Diaphragm", shortName: "Anaerobes\nAbove Diaphragm", category: .anaerobes),

    // Gram Negatives
    Bacterium(id: "pseudomonas", name: "Pseudomonas aeruginosa", shortName: "P. aeruginosa", category: .gramNegative),
    Bacterium(id: "nosocomialGN", name: "Nosocomial Gram Neg. (non-Pseudomonal)", shortName: "Nosocomial GN\n(non-Pseudomonal)", category: .gramNegative),
    Bacterium(id: "communityGN", name: "Community Gram Neg. (Enterobacteriaceae)", shortName: "Community GN\n(Enterobact.)", category: .gramNegative),
]

// MARK: - Antibiotic Coverage Data

// Coverage helper: creates a dictionary from an array of (bacteriumId, coverageLevel) pairs
private func cov(_ pairs: [(String, CoverageLevel)]) -> [String: CoverageLevel] {
    Dictionary(uniqueKeysWithValues: pairs)
}

let allAntibiotics: [Antibiotic] = [
    Antibiotic(id: "amikacin", name: "Amikacin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "amoxicillin", name: "Amoxicillin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .none),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "amoxicillinClav", name: "Amoxicillin Clavulanate", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ampicillinSulb", name: "Ampicillin Sulbactam", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "azithromycin", name: "Azithromycin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .none),
        ("strepNonPneumo", .partial), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "aztreonam", name: "Aztreonam", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefazolin", name: "Cefazolin", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .partial), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefepime", name: "Cefepime", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefotaxime", name: "Cefotaxime", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefotetan", name: "Cefotetan", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefoxitin", name: "Cefoxitin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ceftazidime", name: "Ceftazidime", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ceftriaxone", name: "Ceftriaxone", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "cefuroxime", name: "Cefuroxime", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "ciprofloxacin", name: "Ciprofloxacin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .partial), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "clindamycin", name: "Clindamycin", coverage: cov([
        ("mrsa", .partial), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .partial),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "daptomycin", name: "Daptomycin", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .full),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "dicloxacillin", name: "Dicloxacillin", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .partial), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "doxycycline", name: "Doxycycline", coverage: cov([
        ("mrsa", .partial), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .partial), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .partial)
    ])),
    Antibiotic(id: "ertapenem", name: "Ertapenem", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "erythromycin", name: "Erythromycin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "gentamicin", name: "Gentamicin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .partial),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "imipenem", name: "Imipenem", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "levofloxacin", name: "Levofloxacin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "linezolid", name: "Linezolid", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .full),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "meropenem", name: "Meropenem", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .partial), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "metronidazole", name: "Metronidazole", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "moxifloxacin", name: "Moxifloxacin", coverage: cov([
        ("mrsa", .none), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .partial),
        ("mycoplasma", .full), ("chlamydophila", .full), ("legionella", .full)
    ])),
    Antibiotic(id: "nafcillin", name: "Nafcillin", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .partial), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "nitrofurantoin", name: "Nitrofurantoin", coverage: cov([
        ("mrsa", .partial), ("mssa", .partial), ("staphNonAureus", .partial),
        ("strepNonPneumo", .partial), ("strepPneumo", .none), ("eFaecalis", .full), ("eFaecium", .partial),
        ("communityGN", .partial), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "penicillin", name: "Penicillin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .partial), ("eFaecium", .none),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "pipTazo", name: "Piperacillin Tazobactam", coverage: cov([
        ("mrsa", .none), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "tigecycline", name: "Tigecycline", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .partial), ("eFaecium", .partial),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .full), ("anaerobesBelow", .full),
        ("mycoplasma", .partial), ("chlamydophila", .partial), ("legionella", .none)
    ])),
    Antibiotic(id: "tmpSmx", name: "TMP-SMX", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .partial), ("strepPneumo", .full), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .partial), ("pseudomonas", .none),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "tobramycin", name: "Tobramycin", coverage: cov([
        ("mrsa", .none), ("mssa", .none), ("staphNonAureus", .none),
        ("strepNonPneumo", .none), ("strepPneumo", .none), ("eFaecalis", .none), ("eFaecium", .none),
        ("communityGN", .full), ("nosocomialGN", .full), ("pseudomonas", .full),
        ("anaerobesAbove", .none), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
    Antibiotic(id: "vancomycin", name: "Vancomycin", coverage: cov([
        ("mrsa", .full), ("mssa", .full), ("staphNonAureus", .full),
        ("strepNonPneumo", .full), ("strepPneumo", .full), ("eFaecalis", .full), ("eFaecium", .partial),
        ("communityGN", .none), ("nosocomialGN", .none), ("pseudomonas", .none),
        ("anaerobesAbove", .partial), ("anaerobesBelow", .none),
        ("mycoplasma", .none), ("chlamydophila", .none), ("legionella", .none)
    ])),
]

// MARK: - Detailed Anaerobe Data

enum AnaerobeSubcategory: String, CaseIterable, Identifiable {
    case gramNegative = "Anaerobic Gram Negatives"
    case gramPositive = "Anaerobic Gram Positives"

    var id: String { rawValue }
}

struct DetailedAnaerobe: Identifiable {
    let id: String
    let name: String
    let shortName: String
    let subcategory: AnaerobeSubcategory
}

let allDetailedAnaerobes: [DetailedAnaerobe] = [
    // Anaerobic Gram Negatives
    DetailedAnaerobe(id: "bFragilis", name: "Bacteroides fragilis", shortName: "B. fragilis", subcategory: .gramNegative),
    DetailedAnaerobe(id: "fNecrophorum", name: "Fusobacterium necrophorum", shortName: "F. necrophorum", subcategory: .gramNegative),
    DetailedAnaerobe(id: "prevotella", name: "Prevotella sp.", shortName: "Prevotella", subcategory: .gramNegative),

    // Anaerobic Gram Positives
    DetailedAnaerobe(id: "actinomyces", name: "Actinomyces sp.", shortName: "Actinomyces", subcategory: .gramPositive),
    DetailedAnaerobe(id: "clostridium", name: "Clostridium sp.", shortName: "Clostridium", subcategory: .gramPositive),
    DetailedAnaerobe(id: "cAcnes", name: "Cutibacterium acnes", shortName: "C. acnes", subcategory: .gramPositive),
    DetailedAnaerobe(id: "peptostreptococci", name: "Peptostreptococci", shortName: "Peptostrep", subcategory: .gramPositive),
]

// Coverage helper for anaerobe detail data
private func anaerobeCov(_ pairs: [(String, CoverageLevel)]) -> [String: CoverageLevel] {
    Dictionary(uniqueKeysWithValues: pairs)
}

/// Detailed anaerobe coverage keyed by antibiotic ID
let detailedAnaerobeCoverage: [String: [String: CoverageLevel]] = [
    "amikacin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .none), ("peptostreptococci", .none)
    ]),
    "amoxicillin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .full), ("prevotella", .partial),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "amoxicillinClav": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "ampicillinSulb": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "azithromycin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .none)
    ]),
    "aztreonam": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .none), ("peptostreptococci", .none)
    ]),
    "cefazolin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .partial), ("clostridium", .none), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "cefepime": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .partial), ("prevotella", .partial),
        ("actinomyces", .partial), ("clostridium", .partial), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "cefotaxime": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .partial), ("prevotella", .partial),
        ("actinomyces", .partial), ("clostridium", .partial), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "cefotetan": anaerobeCov([
        ("bFragilis", .partial), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .partial), ("clostridium", .partial), ("cAcnes", .partial), ("peptostreptococci", .partial)
    ]),
    "cefoxitin": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .partial), ("clostridium", .full), ("cAcnes", .partial), ("peptostreptococci", .full)
    ]),
    "ceftazidime": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .partial), ("prevotella", .partial),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .partial)
    ]),
    "ceftriaxone": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .partial), ("prevotella", .partial),
        ("actinomyces", .partial), ("clostridium", .partial), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "cefuroxime": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .partial), ("prevotella", .partial),
        ("actinomyces", .partial), ("clostridium", .partial), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "ciprofloxacin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .none)
    ]),
    "clindamycin": anaerobeCov([
        ("bFragilis", .partial), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .partial), ("cAcnes", .partial), ("peptostreptococci", .full)
    ]),
    "daptomycin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .none), ("peptostreptococci", .none)
    ]),
    "dicloxacillin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .none)
    ]),
    "doxycycline": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .partial), ("prevotella", .partial),
        ("actinomyces", .partial), ("clostridium", .none), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "ertapenem": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "erythromycin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .partial), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .none)
    ]),
    "gentamicin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .none), ("peptostreptococci", .none)
    ]),
    "imipenem": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "levofloxacin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .partial), ("prevotella", .partial),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .none)
    ]),
    "linezolid": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .partial), ("clostridium", .partial), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "meropenem": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "metronidazole": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .none), ("clostridium", .full), ("cAcnes", .none), ("peptostreptococci", .full)
    ]),
    "moxifloxacin": anaerobeCov([
        ("bFragilis", .partial), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .partial), ("clostridium", .partial), ("cAcnes", .full), ("peptostreptococci", .partial)
    ]),
    "nafcillin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .none)
    ]),
    "nitrofurantoin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .none), ("peptostreptococci", .none)
    ]),
    "penicillin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .full), ("prevotella", .partial),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "pipTazo": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "tigecycline": anaerobeCov([
        ("bFragilis", .full), ("fNecrophorum", .full), ("prevotella", .full),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
    "tmpSmx": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .partial), ("peptostreptococci", .none)
    ]),
    "tobramycin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .none), ("clostridium", .none), ("cAcnes", .none), ("peptostreptococci", .none)
    ]),
    "vancomycin": anaerobeCov([
        ("bFragilis", .none), ("fNecrophorum", .none), ("prevotella", .none),
        ("actinomyces", .full), ("clostridium", .full), ("cAcnes", .full), ("peptostreptococci", .full)
    ]),
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
            associatedBacteria: ["communityGN", "eFaecalis", "eFaecium"]),
    Disease(id: "vap", name: "Ventilator Acquired Pneumonia",
            associatedBacteria: ["pseudomonas", "nosocomialGN", "mrsa"]),
    Disease(id: "sepsis", name: "Sepsis - The 5 Killers",
            associatedBacteria: ["strepPneumo", "communityGN", "mssa", "mrsa", "pseudomonas"]),
]
