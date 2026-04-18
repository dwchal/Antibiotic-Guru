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

private struct AnaerobesResource: Codable {
    let anaerobes: [DetailedAnaerobe]
    let detailedCoverage: [AntibioticID: [String: CoverageLevel]]
}

enum ClinicalDataLoader {
    static func load(bundle: Bundle = .main) -> ClinicalDataSnapshot {
        do {
            let bacteriaResource: BacteriaResource = try decode("bacteria", from: bundle)
            let antibioticsResource: AntibioticsResource = try decode("antibiotics", from: bundle)
            let diseasesResource: DiseasesResource = try decode("diseases", from: bundle)
            let anaerobesResource: AnaerobesResource = try decode("anaerobes", from: bundle)

            return ClinicalDataSnapshot(
                metadata: bacteriaResource.metadata,
                bacteria: bacteriaResource.bacteria,
                antibiotics: antibioticsResource.antibiotics,
                diseases: diseasesResource.diseases,
                detailedAnaerobes: anaerobesResource.anaerobes,
                detailedAnaerobeCoverage: anaerobesResource.detailedCoverage,
                loadStatus: ClinicalDataLoadStatus(
                    isLoaded: true,
                    loadedAt: Date(),
                    source: "Bundled JSON Resources",
                    message: "Loaded \(antibioticsResource.antibiotics.count) antibiotics and \(bacteriaResource.bacteria.count) bacteria entries."
                )
            )
        } catch {
            fatalError("Clinical data load failure: \(error)")
        }
    }

    private static func decode<T: Decodable>(_ name: String, from bundle: Bundle) throws -> T {
        guard let url = bundle.url(forResource: name, withExtension: "json", subdirectory: "ClinicalData") else {
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
