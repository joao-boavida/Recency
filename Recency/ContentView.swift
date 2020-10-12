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

    @State private var isAddActivityVisible = false

    @ObservedObject var flightLog = FlightLog()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Text("Current Status Here")
                            .font(.largeTitle)
                        Text("Next Limitation")
                            .font(.headline)
                    }
                    Section {
                        Text("Takeoffs and date")
                        Text("Landings and date")
                    }
                    /*Button("See activities...") {
                        // present sheet to see activities
                    }*/
                    Button("Add Activity...") {
                        isAddActivityVisible = true
                    }
                }

                List { // temporary
                    ForEach(flightLog.data) { activity in
                        Text("\(activity.takeoffDate)")
                        Text("\(activity.takeoffs)")
                    }
                }

            }
            .navigationBarTitle("Recency Monitor")
        }
        .sheet(isPresented: $isAddActivityVisible) {
            AddActivity(flightLog: flightLog)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
