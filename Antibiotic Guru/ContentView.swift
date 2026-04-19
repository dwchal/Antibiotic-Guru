import SwiftUI

struct ContentView: View {
    @State private var selectedAntibiotic: Antibiotic?
    @State private var selectedAntifungal: Antifungal?
    @State private var selectedDisease: Disease?
    @State private var categoryFilter: BacteriaCategory?
    @State private var fungusFilter: FungusCategory?
    @State private var chartMode: ChartMode = .bacteria
    @State private var showAnaerobeDetail = false
    @State private var antibioticSearchText = ""
    @State private var antifungalSearchText = ""
    @State private var diseaseSearchText = ""
    @State private var showAppInfo = false
    @SceneStorage("selectedAntibioticId") private var savedAntibioticId: String?
    @SceneStorage("selectedAntifungalId") private var savedAntifungalId: String?
    @SceneStorage("selectedDiseaseId") private var savedDiseaseId: String?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var coverageMap: [BacteriumID: CoverageLevel] {
        selectedAntibiotic?.coverage ?? [:]
    }

    private var fungalCoverageMap: [FungusID: CoverageLevel] {
        selectedAntifungal?.coverage ?? [:]
    }

    private var highlightedBacteria: Set<BacteriumID> {
        if let disease = selectedDisease {
            return Set(disease.associatedBacteria)
        }
        return []
    }

    private var highlightedFungi: Set<FungusID> {
        if let disease = selectedDisease {
            return Set(disease.associatedFungi)
        }
        return []
    }

    private var filteredAntibiotics: [Antibiotic] {
        guard !antibioticSearchText.isEmpty else { return allAntibiotics }
        return allAntibiotics.filter { $0.name.localizedCaseInsensitiveContains(antibioticSearchText) }
    }

    private var filteredAntifungals: [Antifungal] {
        guard !antifungalSearchText.isEmpty else { return allAntifungals }
        return allAntifungals.filter { $0.name.localizedCaseInsensitiveContains(antifungalSearchText) }
    }

    private var filteredDiseases: [Disease] {
        guard !diseaseSearchText.isEmpty else { return allDiseases }
        return allDiseases.filter { $0.name.localizedCaseInsensitiveContains(diseaseSearchText) }
    }

    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                compactLayout
            } else {
                regularLayout
            }
        }
        .onAppear(perform: restoreSelection)
        .sheet(isPresented: $showAnaerobeDetail) {
            AnaerobeDetailView(selectedAntibiotic: selectedAntibiotic)
        }
        .sheet(isPresented: $showAppInfo) {
            AppInfoView()
        }
    }

    // MARK: - Regular Layout (iPad / Mac)

    private var regularLayout: some View {
        VStack(spacing: 0) {
            titleBar
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    AntibioticsSidebarView(
                        antibiotics: allAntibiotics,
                        selectedAntibiotic: $selectedAntibiotic,
                        searchText: $antibioticSearchText,
                        onSelect: selectAntibiotic
                    )
                    Divider()
                    AntifungalsSidebarView(
                        antifungals: allAntifungals,
                        selectedAntifungal: $selectedAntifungal,
                        searchText: $antifungalSearchText,
                        onSelect: selectAntifungal
                    )
                }
                .frame(width: 220)
                Divider()
                chartSection
                Divider()
                DiseasesSidebarView(
                    diseases: allDiseases,
                    bacteria: allBacteria,
                    fungi: allFungi,
                    coverageMap: coverageMap,
                    fungalCoverageMap: fungalCoverageMap,
                    highlightedBacteria: highlightedBacteria,
                    highlightedFungi: highlightedFungi,
                    selectedDisease: $selectedDisease,
                    searchText: $diseaseSearchText,
                    onSelect: selectDisease
                )
                .frame(width: 240)
            }
            Divider()
            FilterBarView(
                categoryFilter: $categoryFilter,
                fungusFilter: $fungusFilter,
                showAnaerobeDetail: $showAnaerobeDetail,
                chartMode: chartMode
            )
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
        }
    }

    // MARK: - Compact Layout (iPhone)

    private var compactLayout: some View {
        TabView {
            Tab("Chart", systemImage: "chart.pie") {
                VStack(spacing: 4) {
                    HStack {
                        selectionHeader
                        Spacer()
                        appInfoButton
                    }
                    .padding(.horizontal, 12)
                    chartSection
                    FilterBarView(
                        categoryFilter: $categoryFilter,
                        fungusFilter: $fungusFilter,
                        showAnaerobeDetail: $showAnaerobeDetail,
                        chartMode: chartMode
                    )
                    .padding(.vertical, 6)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground).ignoresSafeArea())
            }
            Tab("Antibiotics", systemImage: "pills") {
                NavigationStack {
                    antibioticsListPhone
                        .navigationTitle("Antibiotics")
                }
            }
            Tab("Antifungals", systemImage: "leaf") {
                NavigationStack {
                    antifungalsListPhone
                        .navigationTitle("Antifungals")
                }
            }
            Tab("Diseases", systemImage: "cross.case") {
                NavigationStack {
                    diseasesListPhone
                        .navigationTitle("Reference")
                }
            }
        }
    }

    // MARK: - Shared Components

    private var titleBar: some View {
        ZStack {
            Text("Antibiotic Guru")
                .font(.title.bold())

            HStack {
                Spacer()
                appInfoButton
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
    }

    private var appInfoButton: some View {
        Button {
            showAppInfo = true
        } label: {
            Image(systemName: "info.circle")
                .font(.title3)
                .foregroundColor(.secondary)
                .accessibilityLabel("App information")
        }
    }

    private var selectionHeader: some View {
        Group {
            if let abx = selectedAntibiotic {
                Text(abx.name)
                    .font(.headline)
                    .foregroundColor(.blue)
            } else if let af = selectedAntifungal {
                Text(af.name)
                    .font(.headline)
                    .foregroundColor(.teal)
            } else if let disease = selectedDisease {
                Text(disease.name)
                    .font(.headline)
                    .foregroundColor(.orange)
            } else {
                Text("Select an antibiotic, antifungal, or disease")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 8)
    }

    private var chartSection: some View {
        VStack(spacing: 8) {
            if horizontalSizeClass != .compact {
                selectionHeader
            }
            Picker("Coverage View", selection: $chartMode) {
                Text("Bacteria").tag(ChartMode.bacteria)
                Text("Fungi").tag(ChartMode.fungi)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 12)
            switch chartMode {
            case .bacteria:
                SpectrumPieChartView(
                    bacteria: allBacteria,
                    coverageMap: coverageMap,
                    highlightedBacteria: highlightedBacteria,
                    categoryFilter: categoryFilter
                )
            case .fungi:
                SpectrumPieChartView(
                    fungi: allFungi,
                    coverageMap: fungalCoverageMap,
                    highlightedFungi: highlightedFungi,
                    categoryFilter: fungusFilter
                )
            }
        }
        .padding(.horizontal, horizontalSizeClass == .compact ? 0 : 8)
        .padding(.vertical, 8)
    }

    // MARK: - Phone Lists

    private var antibioticsListPhone: some View {
        List(filteredAntibiotics) { abx in
            Button {
                selectAntibiotic(abx)
            } label: {
                HStack {
                    Text(abx.name)
                        .foregroundColor(.primary)
                    Spacer()
                    if selectedAntibiotic?.id == abx.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .searchable(text: $antibioticSearchText, prompt: "Search antibiotics")
    }

    private var antifungalsListPhone: some View {
        List(filteredAntifungals) { af in
            Button {
                selectAntifungal(af)
            } label: {
                HStack {
                    Text(af.name)
                        .foregroundColor(.primary)
                    Spacer()
                    if selectedAntifungal?.id == af.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.teal)
                    }
                }
            }
        }
        .searchable(text: $antifungalSearchText, prompt: "Search antifungals")
    }

    private var diseasesListPhone: some View {
        List {
            Section("Diseases") {
                ForEach(filteredDiseases) { disease in
                    Button {
                        selectDisease(disease)
                    } label: {
                        HStack {
                            Text(disease.name)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedDisease?.id == disease.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }

            ForEach(groupedBacteria, id: \.category) { group in
                Section(group.category.displayName) {
                    ForEach(group.bacteria) { bact in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(bacteriaIndicatorColor(for: bact))
                                .frame(width: 12, height: 12)
                            Text(bact.name)
                                .font(.subheadline)
                        }
                    }
                }
            }

            ForEach(groupedFungi, id: \.category) { group in
                Section(group.category.displayName) {
                    ForEach(group.fungi) { fungus in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(fungusIndicatorColor(for: fungus))
                                .frame(width: 12, height: 12)
                            Text(fungus.name)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .searchable(text: $diseaseSearchText, prompt: "Search diseases")
    }

    private var groupedBacteria: [(category: BacteriaCategory, bacteria: [Bacterium])] {
        BacteriaCategory.allCases.map { category in
            (category, allBacteria.filter { $0.category == category })
        }
    }

    private var groupedFungi: [(category: FungusCategory, fungi: [Fungus])] {
        FungusCategory.allCases.map { category in
            (category, allFungi.filter { $0.category == category })
        }
    }

    private func bacteriaIndicatorColor(for bacterium: Bacterium) -> Color {
        if !highlightedBacteria.isEmpty {
            return highlightedBacteria.contains(bacterium.id) ? .orange : Color.gray.opacity(0.4)
        }
        return coverageMap[bacterium.id]?.displayColor ?? Color.gray.opacity(0.4)
    }

    private func fungusIndicatorColor(for fungus: Fungus) -> Color {
        if !highlightedFungi.isEmpty {
            return highlightedFungi.contains(fungus.id) ? .orange : Color.gray.opacity(0.4)
        }
        return fungalCoverageMap[fungus.id]?.displayColor ?? Color.gray.opacity(0.4)
    }

    // MARK: - Selection

    private func selectAntibiotic(_ antibiotic: Antibiotic) {
        chartMode = .bacteria
        selectedDisease = nil
        savedDiseaseId = nil
        selectedAntifungal = nil
        savedAntifungalId = nil
        fungusFilter = nil
        if selectedAntibiotic?.id == antibiotic.id {
            selectedAntibiotic = nil
            savedAntibioticId = nil
        } else {
            selectedAntibiotic = antibiotic
            savedAntibioticId = antibiotic.id.rawValue
        }
    }

    private func selectAntifungal(_ antifungal: Antifungal) {
        chartMode = .fungi
        selectedDisease = nil
        savedDiseaseId = nil
        selectedAntibiotic = nil
        savedAntibioticId = nil
        categoryFilter = nil
        if selectedAntifungal?.id == antifungal.id {
            selectedAntifungal = nil
            savedAntifungalId = nil
        } else {
            selectedAntifungal = antifungal
            savedAntifungalId = antifungal.id.rawValue
        }
    }

    private func selectDisease(_ disease: Disease) {
        selectedAntibiotic = nil
        savedAntibioticId = nil
        selectedAntifungal = nil
        savedAntifungalId = nil
        if selectedDisease?.id == disease.id {
            selectedDisease = nil
            savedDiseaseId = nil
        } else {
            selectedDisease = disease
            savedDiseaseId = disease.id
        }
    }

    private func restoreSelection() {
        if let id = savedAntibioticId {
            selectedAntibiotic = allAntibiotics.first { $0.id.rawValue == id }
            chartMode = .bacteria
        } else if let id = savedAntifungalId {
            selectedAntifungal = allAntifungals.first { $0.id.rawValue == id }
            chartMode = .fungi
        } else if let id = savedDiseaseId {
            selectedDisease = allDiseases.first { $0.id == id }
        }
    }
}

#Preview {
    ContentView()
}
