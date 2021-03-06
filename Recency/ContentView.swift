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
    case notificationsRequest

    var id: String {
        UUID().uuidString
    }
}

/// This is the app's main view
struct ContentView: View {

    let secondPlusRunStorageKey = "SecondPlusRun"

    /// holds the active sheet
    @State private var activeSheet: ActiveSheet?

    @State private var now = Date()

    /// The app's database
    @StateObject var flightLog = FlightLog()

    /// Validity is only shown if recency is valid.
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
                        /*#if DEBUG
                        // Functions used for development purposes
                        Section(header: Text("Development Only")) {
                            Button("Print Pending Notifications") {
                                NotificationsManager.printPendingNotifications()
                            }
                            Button("Check Apple Auth Status") {
                                print("Apple Authorisation Status")
                                UNUserNotificationCenter.current().getNotificationSettings { settings in

                                    switch settings.authorizationStatus {
                                    case .authorized: print("authorized")
                                    case .denied: print("denied")
                                    case .notDetermined: print("not determined")
                                    default: print("other")
                                    }
                                }
                            }
                            Button("Check Local Auth Status") {
                                print("Local Authorisation Status")
                                switch flightLog.localNotificationPreferences {
                                case .allowed: print("allowed")
                                case .denied: print("denied")
                                case .unknown: print("unknown")
                                case .maybeLater: print("maybe later")
                                }
                            }
                            Button("Test Standard Notifications") {
                                NotificationsManager.testStandardNotifications()
                            }
                        }
                        #endif*/
                    }

                }
                .navigationBarTitle("Recency Monitor")
            }
        }
        //this sheet modifier uses the ActiveSheet enum to decide which sheet should be shown. Only one sheet is displayed at a time.
        .sheet(item: $activeSheet) { item in
            switch item {
            case .addActivity:
                NavigationView {
                    AddActivity(flightLog: flightLog)
                }.onDisappear {
                    now = Date()
                    if flightLog.isRecencyValid(at: now) && flightLog.localNotificationPreferences == .unknown {
                        activeSheet = .notificationsRequest
                    }
                }
            case .welcomeSheet:
                WelcomeSheet()
            case .notificationsRequest:
                NotificationsRequestView(flightLog: flightLog)
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

            if flightLog.isRecencyValid(at: now) {

                //if recency is valid now the app's icon should not be badged
                UIApplication.shared.applicationIconBadgeNumber = 0

                //furthermore, if either the user did not yet make a choice on notification preferences (perhaps they have just upgraded) or they have said "maybe later" now would be a good time to prompt them.
                if flightLog.localNotificationPreferences == .maybeLater || flightLog.localNotificationPreferences == .unknown {
                    activeSheet = .notificationsRequest
                }
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
