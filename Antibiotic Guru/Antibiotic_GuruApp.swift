//
//  Antibiotic_GuruApp.swift
//  Antibiotic Guru
//
//  Created by Doug Challener on 4/14/26.
//

import SwiftUI

@main
struct Antibiotic_GuruApp: App {
    init() {
        #if DEBUG
        validateClinicalData()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
