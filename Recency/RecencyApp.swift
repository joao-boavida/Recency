//
//  RecencyApp.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

@main
struct RecencyApp: App {

    // "--uitesting" command line argument is passed when the app is used for testing, and causes the app to revert to its initial state.
    init() {
        if CommandLine.arguments.contains("--uitesting") {
            resetState()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    // clear user defaults to clear app state.
    func resetState() {
        let defaultsName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: defaultsName)
    }
}
