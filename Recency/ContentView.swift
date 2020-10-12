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

enum ActiveSheet: Identifiable {

    case seeActivities, addActivity
    var id: String {
        UUID().uuidString
    }
}

class FlightLog: ObservableObject {

    let storageKey = "FlightActivity"

    @Published var data = [FlightActivity]()
}

struct ContentView: View {

    @State private var isAddActivityVisible = false
    @State private var isSeeActivitiesVisible = false

    @State private var activeSheet: ActiveSheet?

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
                        Text("3 Takeoffs exp date")
                        Text("3 Landings exp date")
                    }
                    Button("See Activities...") {
                        activeSheet = .seeActivities
                        //isSeeActivitiesVisible = true
                    }
                    Button("Add Activity...") {
                        activeSheet = .addActivity
                        //isAddActivityVisible = true
                    }
                }

            }
            .navigationBarTitle("Recency Monitor")
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .seeActivities:
                SeeActivities(flightLog: flightLog)
            case .addActivity:
            AddActivity(flightLog: flightLog)
            }
        }
        /*.sheet(isPresented: $isSeeActivitiesVisible) {
            SeeActivities(flightLog: flightLog)
        }*/
        /*.sheet(isPresented: $isAddActivityVisible) {
            AddActivity(flightLog: flightLog)
        }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
