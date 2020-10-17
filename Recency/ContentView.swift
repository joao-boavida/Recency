//
//  ContentView.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

/// this enum is used for managing multiple sheets
enum ActiveSheet: Identifiable {

    case addActivity
    case welcomeSheet

    var id: String {
        UUID().uuidString
    }
}

/// This is the app's main view
struct ContentView: View {

    let secondPlusRunStorageKey = "SecondPlusRun"

    @State private var activeSheet: ActiveSheet?

    /// The app's database
    @ObservedObject var flightLog = FlightLog()

    var currentRecency: Text {
        if flightLog.isRecencyValid(at: Date()) {
            return Text("Recency OK")
        } else {
            return Text("Recency Expired")
        }
    }

    var showingValidity: Bool {
        flightLog.isRecencyValid(at: Date())
    }

    var nextLimitation: Text {
        let recency = flightLog.checkRecency()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let description = dateFormatter.string(from: recency)
        return Text("Valid until \(description)")
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            currentRecency
                                .font(.largeTitle)
                            Spacer()
                        }
                        if showingValidity {
                            NavigationLink(destination: RecencyDetail(flightLog: flightLog)) {
                                nextLimitation
                                    .font(.headline)
                            }
                        }
                    }.foregroundColor(showingValidity ? .green : .red)

                    .multilineTextAlignment(.center)
                    Section(header: Text("Latest 3 Activities")) {
                        if flightLog.data.isEmpty {
                            Text("Add activities to begin.")
                        } else {
                            ForEach(flightLog.data.prefix(3)) { activity in
                                ActivityDetail(activity: activity)
                            }
                        }
                    }
                    Button("Add Activity...") {
                        activeSheet = .addActivity
                    }
                    .font(.headline)
                }

            }
            .navigationBarTitle("Recency Monitor")
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .addActivity:
                AddActivity(flightLog: flightLog)
            case .welcomeSheet:
                WelcomeSheet()
            }
        }
        .onAppear {
            //check for first run here
            if UserDefaults.standard.bool(forKey: secondPlusRunStorageKey) == false {
                //first run
                UserDefaults.standard.set(true, forKey: secondPlusRunStorageKey)
                activeSheet = .welcomeSheet
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}
