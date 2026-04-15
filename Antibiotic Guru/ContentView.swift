import SwiftUI

struct ContentView: View {
    @State private var selectedAntibiotic: Antibiotic?
    @State private var selectedDisease: Disease?
    @State private var categoryFilter: BacteriaCategory?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var coverageMap: [String: CoverageLevel] {
        selectedAntibiotic?.coverage ?? [:]
    }

    private var highlightedBacteria: Set<String> {
        if let disease = selectedDisease {
            return Set(disease.associatedBacteria)
        }
        return []
    }

    var body: some View {
        if horizontalSizeClass == .compact {
            compactLayout
        } else {
            regularLayout
        }
    }

    // MARK: - Regular Layout (iPad / Mac)

    private var regularLayout: some View {
        VStack(spacing: 0) {
            titleBar
            HStack(spacing: 0) {
                antibioticsSidebar
                    .frame(width: 220)
                Divider()
                chartSection
                Divider()
                diseasesSidebar
                    .frame(width: 240)
            }
            Divider()
            filterBar
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
            disclaimer
        }
    }

    // MARK: - Compact Layout (iPhone)

    private var compactLayout: some View {
        TabView {
            Tab("Chart", systemImage: "chart.pie") {
                VStack(spacing: 4) {
                    selectionHeader
                    chartSection
                    filterBar
                        .padding(.vertical, 6)
                    disclaimer
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
        HStack {
            Spacer()
            Text("Antibiotic Guru")
                .font(.title.bold())
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
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

    private var disclaimer: some View {
        Text("This app is for educational purposes only. It is not a substitute for clinical judgement.")
            .font(.caption2)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.bottom, 4)
    }

    // MARK: - Antibiotics Sidebar (iPad/Mac)

    private var antibioticsSidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Antibiotics")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(allAntibiotics) { abx in
                        antibioticRow(abx)
                        Divider().padding(.leading, 12)
                    }
                }
            }
        }
    }

    // MARK: - Antibiotics List (iPhone)

    private var antibioticsListPhone: some View {
        List(allAntibiotics) { abx in
            Button {
                selectedDisease = nil
                if selectedAntibiotic?.id == abx.id {
                    selectedAntibiotic = nil
                } else {
                    selectedAntibiotic = abx
                }
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
    }

    // MARK: - Diseases Sidebar (iPad/Mac)

    private var diseasesSidebar: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Diseases")
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)

                    ForEach(allDiseases) { disease in
                        diseaseRow(disease)
                    }
                }

                Divider()

                bacteriaGroupsList
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Diseases List (iPhone)

    private var diseasesListPhone: some View {
        List {
            Section("Diseases") {
                ForEach(allDiseases) { disease in
                    Button {
                        selectedAntibiotic = nil
                        if selectedDisease?.id == disease.id {
                            selectedDisease = nil
                        } else {
                            selectedDisease = disease
                        }
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

            ForEach(BacteriaCategory.allCases) { category in
                Section(category.rawValue) {
                    ForEach(allBacteria.filter { $0.category == category }) { bact in
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
    }

    // MARK: - Shared Row Components

    private func antibioticRow(_ abx: Antibiotic) -> some View {
        Button {
            selectedDisease = nil
            if selectedAntibiotic?.id == abx.id {
                selectedAntibiotic = nil
            } else {
                selectedAntibiotic = abx
            }
        } label: {
            Text(abx.name)
                .font(.system(size: 14))
                .foregroundColor(selectedAntibiotic?.id == abx.id ? .white : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    selectedAntibiotic?.id == abx.id ? Color.blue : Color.clear
                )
        }
        .buttonStyle(.plain)
    }

    private func diseaseRow(_ disease: Disease) -> some View {
        Button {
            selectedAntibiotic = nil
            if selectedDisease?.id == disease.id {
                selectedDisease = nil
            } else {
                selectedDisease = disease
            }
        } label: {
            Text(disease.name)
                .font(.system(size: 13))
                .foregroundColor(selectedDisease?.id == disease.id ? .white : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    selectedDisease?.id == disease.id ? Color.orange : Color.clear
                )
        }
        .buttonStyle(.plain)
    }

    private var bacteriaGroupsList: some View {
        ForEach(BacteriaCategory.allCases) { category in
            VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                    .font(.subheadline.bold())
                    .padding(.horizontal, 12)

                ForEach(allBacteria.filter { $0.category == category }) { bact in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(bacteriaIndicatorColor(for: bact))
                            .frame(width: 10, height: 10)
                        Text(bact.name)
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 1)
                }
            }
            .padding(.bottom, 4)
        }
    }

    private func bacteriaIndicatorColor(for bacterium: Bacterium) -> Color {
        if !highlightedBacteria.isEmpty {
            return highlightedBacteria.contains(bacterium.id) ? .orange : Color.gray.opacity(0.4)
        }
        guard let level = coverageMap[bacterium.id] else { return Color.gray.opacity(0.4) }
        switch level {
        case .none: return Color.gray.opacity(0.4)
        case .partial: return .yellow
        case .full: return .green
        }
    }

    // MARK: - Filter Bar

    private var filterBar: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                filterButton("All", category: nil, color: .blue)
                filterButton("Gram Positive", category: .gramPositive, color: .green)
                filterButton("Gram Negative", category: .gramNegative, color: .red)
            }
            HStack(spacing: 8) {
                filterButton("Anaerobes", category: .anaerobes, color: .orange)
                filterButton("Atypicals", category: .atypicals, color: .purple)
            }
        }
        .padding(.horizontal)
    }

    private func filterButton(_ title: String, category: BacteriaCategory?, color: Color) -> some View {
        let isSelected = categoryFilter == category
        return Button {
            categoryFilter = isSelected ? nil : category
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : color.opacity(0.15))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
