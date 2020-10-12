//
//  ContentView.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

struct FlightActivity: Identifiable, Codable {
    var id = UUID()
    var insertionDate = Date()
    let takeoffs: Int
    let takeoffDate: Date
    let landings: Int
    let landingDates: Date
}

class FlightLog: ObservableObject {

    let storageKey = "FlightActivity"

    @Published var data = [FlightActivity]()
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    Text("Current Status Here")
                        .font(.largeTitle)
                    Text("Next Limitation")
                        .font(.headline)
                }
                Form {
                    Section {
                        Text("Takeoffs and date")
                        Text("Landings and date")
                    }
                    Button("See activities...") {
                        // present sheet to see activities
                    }
                    Button("Add Activity...") {
                    //Present sheet to add activity
                    }

                }
            }
            .navigationBarTitle("Recency Monitor")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
