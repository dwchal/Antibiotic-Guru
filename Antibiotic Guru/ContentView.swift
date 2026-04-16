import SwiftUI

struct ContentView: View {
    @State private var selectedAntibiotic: Antibiotic?
    @State private var selectedDisease: Disease?
    @State private var categoryFilter: BacteriaCategory?
    @State private var showAnaerobeDetail = false
    @State private var antibioticSearchText = ""
    @State private var diseaseSearchText = ""
    @State private var showAppInfo = false
    @SceneStorage("selectedAntibioticId") private var savedAntibioticId: String?
    @SceneStorage("selectedDiseaseId") private var savedDiseaseId: String?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var coverageMap: [BacteriumID: CoverageLevel] {
        selectedAntibiotic?.coverage ?? [:]
    }

    private var highlightedBacteria: Set<BacteriumID> {
        if let disease = selectedDisease {
            return Set(disease.associatedBacteria)
        }
        return []
    }

    private var filteredAntibiotics: [Antibiotic] {
        guard !antibioticSearchText.isEmpty else { return allAntibiotics }
        return allAntibiotics.filter { $0.name.localizedCaseInsensitiveContains(antibioticSearchText) }
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
                AntibioticsSidebarView(
                    antibiotics: allAntibiotics,
                    selectedAntibiotic: $selectedAntibiotic,
                    searchText: $antibioticSearchText,
                    onSelect: selectAntibiotic
                )
                .frame(width: 220)
                Divider()
                chartSection
                Divider()
                DiseasesSidebarView(
                    diseases: allDiseases,
                    bacteria: allBacteria,
                    coverageMap: coverageMap,
                    highlightedBacteria: highlightedBacteria,
                    selectedDisease: $selectedDisease,
                    searchText: $diseaseSearchText,
                    onSelect: selectDisease
                )
                .frame(width: 240)
            }
            Divider()
            FilterBarView(categoryFilter: $categoryFilter, showAnaerobeDetail: $showAnaerobeDetail)
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
                    FilterBarView(categoryFilter: $categoryFilter, showAnaerobeDetail: $showAnaerobeDetail)
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
            } else if let disease = selectedDisease {
                Text(disease.name)
                    .font(.headline)
                    .foregroundColor(.orange)
            } else {
                Text("Select an antibiotic or disease")
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
            SpectrumPieChartView(
                bacteria: allBacteria,
                coverageMap: coverageMap,
                highlightedBacteria: highlightedBacteria,
                categoryFilter: categoryFilter
            )
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
                Section(group.category.rawValue) {
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
        }
        .searchable(text: $diseaseSearchText, prompt: "Search diseases")
    }

    private var groupedBacteria: [(category: BacteriaCategory, bacteria: [Bacterium])] {
        BacteriaCategory.allCases.map { category in
            (category, allBacteria.filter { $0.category == category })
        }
    }

    private func bacteriaIndicatorColor(for bacterium: Bacterium) -> Color {
        if !highlightedBacteria.isEmpty {
            return highlightedBacteria.contains(bacterium.id) ? .orange : Color.gray.opacity(0.4)
        }
        return coverageMap[bacterium.id]?.displayColor ?? Color.gray.opacity(0.4)
    }

    // MARK: - Selection

    private func selectAntibiotic(_ antibiotic: Antibiotic) {
        selectedDisease = nil
        savedDiseaseId = nil
        if selectedAntibiotic?.id == antibiotic.id {
            selectedAntibiotic = nil
            savedAntibioticId = nil
        } else {
            selectedAntibiotic = antibiotic
            savedAntibioticId = antibiotic.id.rawValue
        }
    }

    private func selectDisease(_ disease: Disease) {
        selectedAntibiotic = nil
        savedAntibioticId = nil
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
        } else if let id = savedDiseaseId {
            selectedDisease = allDiseases.first { $0.id == id }
        }
    }
}

#Preview {
    ContentView()
}
