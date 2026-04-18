import Foundation

private struct BacteriaResource: Codable {
    let metadata: ClinicalDataMetadata
    let bacteria: [Bacterium]
}

private struct AntibioticsResource: Codable {
    let antibiotics: [Antibiotic]
}

private struct DiseasesResource: Codable {
    let diseases: [Disease]
}

private struct FungiResource: Codable {
    let fungi: [Fungus]
}

private struct AntifungalsResource: Codable {
    let antifungals: [Antifungal]
}

private struct AnaerobesResource: Codable {
    let anaerobes: [DetailedAnaerobe]
    let detailedCoverage: [AntibioticID: [String: CoverageLevel]]

    private enum CodingKeys: String, CodingKey {
        case anaerobes, detailedCoverage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        anaerobes = try container.decode([DetailedAnaerobe].self, forKey: .anaerobes)
        let raw = try container.decode([String: [String: CoverageLevel]].self, forKey: .detailedCoverage)
        detailedCoverage = try raw.reduce(into: [:]) { result, pair in
            guard let key = AntibioticID(rawValue: pair.key) else {
                throw DecodingError.dataCorruptedError(forKey: .detailedCoverage, in: container, debugDescription: "Unknown antibiotic ID: \(pair.key)")
            }
            result[key] = pair.value
        }
    }
}

enum ClinicalDataLoader {
    static func load(bundle: Bundle = .main) -> ClinicalDataSnapshot {
        do {
            let bacteriaResource: BacteriaResource = try decode("bacteria", from: bundle)
            let antibioticsResource: AntibioticsResource = try decode("antibiotics", from: bundle)
            let diseasesResource: DiseasesResource = try decode("diseases", from: bundle)
            let anaerobesResource: AnaerobesResource = try decode("anaerobes", from: bundle)
            let fungiResource: FungiResource = try decode("fungi", from: bundle)
            let antifungalsResource: AntifungalsResource = try decode("antifungals", from: bundle)

            return ClinicalDataSnapshot(
                metadata: bacteriaResource.metadata,
                bacteria: bacteriaResource.bacteria,
                antibiotics: antibioticsResource.antibiotics,
                diseases: diseasesResource.diseases,
                detailedAnaerobes: anaerobesResource.anaerobes,
                detailedAnaerobeCoverage: anaerobesResource.detailedCoverage,
                fungi: fungiResource.fungi,
                antifungals: antifungalsResource.antifungals,
                loadStatus: ClinicalDataLoadStatus(
                    isLoaded: true,
                    loadedAt: Date(),
                    source: "Bundled JSON Resources",
                    message: "Loaded \(antibioticsResource.antibiotics.count) antibiotics, \(antifungalsResource.antifungals.count) antifungals, and \(bacteriaResource.bacteria.count) bacteria entries."
                )
            )
        } catch {
            fatalError("Clinical data load failure: \(error)")
        }
    }

    private static func decode<T: Decodable>(_ name: String, from bundle: Bundle) throws -> T {
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw ClinicalDataLoaderError.missingResource(name)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

enum ClinicalDataLoaderError: Error, LocalizedError {
    case missingResource(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            return "Missing bundled resource: \(name).json"
        }
    }
}
