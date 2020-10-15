//
//  ContentView.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

// swiftlint:disable identifier_name

import SwiftUI

/* used since the navigation view only supports one sheet declaration. this enum manages the sheet to be shown*/

enum ActiveSheet: Identifiable {

    case addActivity
    var id: String {
        UUID().uuidString
    }
}

struct ContentView: View {

    @State private var isAddActivityVisible = false
    @State private var isSeeActivitiesVisible = false

    @State private var activeSheet: ActiveSheet?

    @ObservedObject var flightLog = FlightLog()

    var currentRecency: Text {
        //recency is ok as long as the determined date is not in the past and also not earlier today.
        if flightLog.checkRecency() < Date() && !Calendar.current.isDateInToday(flightLog.checkRecency()) {
            return Text("Recency Expired")
        } else {
            return Text("Recency OK")
        }
    }

    var showingValidity: Bool {
        flightLog.checkRecency() >= Date()
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
                        currentRecency
                            .font(.largeTitle)
                        if showingValidity {
                            NavigationLink(destination: RecencyDetail(flightLog: flightLog)) {
                                nextLimitation
                                    .font(.headline)
                            }
                        }
                    }
                    Button("Add Activity...") {
                        activeSheet = .addActivity
                    }
                }

            }
            .navigationBarTitle("Recency Monitor")
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .addActivity:
            AddActivity(flightLog: flightLog)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
