//
//  ContentView.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

/* used since the navigation view only supports one sheet declaration. this enum manages the sheet to be shown*/

enum ActiveSheet: Identifiable {

    case seeActivities, addActivity
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
        if flightLog.checkRecency() < Date() {
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
                            NavigationLink(destination: RecencyDetail(takeOffLimitation: flightLog.checkTakeoffRecency(), landingLimitation: flightLog.checkLandingRecency())) {
                                nextLimitation
                                    .font(.headline)
                            }
                        }
                    }
                    
                    Button("See Activities... Debug: \(flightLog.data.count)") {
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
