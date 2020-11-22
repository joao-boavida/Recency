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

    @State private var now = Date()

    /// The app's database
    @StateObject var flightLog = FlightLog()

    var showingValidity: Bool {
        flightLog.isRecencyValid(at: now)
    }

    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    Form {
                        ValidityView(validityDate: flightLog.recencyValidity, recencyValid: flightLog.isRecencyValid(at: now), destination: AnyView(RecencyDetail(flightLog: flightLog)))
                        Section(header: Text("Latest 3 Activities").padding(.horizontal)) {
                            if flightLog.data.isEmpty {
                                Text("Add activities to begin.")
                                    .accessibility(identifier: "addActivitiesToBeginText")
                            } else {
                                ForEach(flightLog.data.prefix(3)) { activity in
                                    ActivityDetail(flightLog: flightLog, movementCellWidth: geo.size.width/20, activity: activity)
                                }
                                .onDelete(perform: removeItems)
                            }
                        }
                        Button("Add Activity...") {
                            activeSheet = .addActivity
                        }
                        .font(.headline)
                        .accessibility(identifier: "addActivityButton")
                        #if DEBUG
                        // for development purposes
                        Section(header: Text("Development Only")) {
                            /*
                            Button("Request Notification Permission") {
                                NotificationsManager.requestPermission()
                            }
                            Button("Schedule Test Notifications") {

                                NotificationsManager.removePendingNotifications()

                                NotificationsManager.testStandardNotifications()
                            }
                            Button("Schedule Notification From Recency") {
                                NotificationsManager.removePendingNotifications()
                                NotificationsManager.scheduleNotificationsFromRecencyDate(recencyDate: flightLog.recencyValidity)
                            }*/
                            Button("Print Pending Notifications") {
                                NotificationsManager.printPendingNotifications()
                            }
                            Button("Check Auth Status") {
                                UNUserNotificationCenter.current().getNotificationSettings { settings in

                                    switch settings.authorizationStatus {
                                    case .authorized: print("authorized")
                                    case .denied: print("denied")
                                    default: print("other")
                                    }
                                }
                            }
                        }
                        #endif
                    }

                }
                .navigationBarTitle("Recency Monitor")
            }
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
            //update reference date
            now = Date()
            //check for first run here
            if UserDefaults.standard.bool(forKey: secondPlusRunStorageKey) == false {
                //first run
                UserDefaults.standard.set(true, forKey: secondPlusRunStorageKey)
                activeSheet = .welcomeSheet
            }
        }
    }

    /// Handles activity deletion from the data array
    /// - Parameter offsets: offsets from the line the user selected for deletion
    func removeItems(at offsets: IndexSet) {
        flightLog.removeActivity(at: offsets)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)

    }
}
