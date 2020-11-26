//
//  RecencyDetail.swift
//  Recency
//
//  Created by Joao Boavida on 13/10/2020.
//

import SwiftUI

/// Main view of the recency detail screen showing landing and take-off validity as well as an activity log
struct RecencyDetail: View {

    @ObservedObject var flightLog: FlightLog

    var body: some View {
        GeometryReader { geo in
            Form {
                Section(header: Text("Takeoff and Landing Validity")) {
                    ValidityDetail(takeoffsValidityDate: flightLog.takeoffRecencyValidity, landingsValidityDate: flightLog.landingRecencyValidity, takeoffValidityStatus: flightLog.areTakeoffsValid(at: Date()), landingValidityStatus: flightLog.areLandingsValid(at: Date()))
                }.padding([.top, .bottom], 10)

                Section(header: Text("Activity log")) {
                    if flightLog.data.isEmpty {
                        Text("There are no activities to display.")
                    } else {
                        ForEach(flightLog.data) { activity in
                            ActivityDetail(flightLog: flightLog, movementCellWidth: geo.size.width/20, activity: activity)
                        }
                        .onDelete(perform: removeItems)
                    }
                }.padding([.top, .bottom], 10)
            }
        }
        .navigationBarTitle("Recency Detail", displayMode: .inline)
    }

    /// Handles activity deletion from the data array
    /// - Parameter offsets: offsets from the line the user selected for deletion
    func removeItems(at offsets: IndexSet) {
        flightLog.removeActivity(at: offsets)
    }
}

struct RecencyDetail_Previews: PreviewProvider {
    static var previews: some View {

        let sampleFlightLog = FlightLog(emptyLog: true)

        // referenceDate

        var components = DateComponents()
        components.year = 2020
        components.month = 10
        components.day = 4
        //components.calendar = .current

        let referenceDate = Calendar.current.date(from: components)!

        let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)

        // 3 days ago
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!

        let movement2 = FlightActivity(takeoffs: 2, activityDate: threeDaysAgo, landings: 2)

        // 30 days ago
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: referenceDate)!

        let movement3 = FlightActivity(takeoffs: 1, activityDate: thirtyDaysAgo, landings: 1)

        // 100 days ago
        let hundredDaysAgo = Calendar.current.date(byAdding: .day, value: -100, to: referenceDate)!

        let movement4 = FlightActivity(takeoffs: 1, activityDate: hundredDaysAgo, landings: 1)

        sampleFlightLog.addActivity(activity: movement1)
        sampleFlightLog.addActivity(activity: movement2)
        sampleFlightLog.addActivity(activity: movement3)
        sampleFlightLog.addActivity(activity: movement4)

        return
            NavigationView {
                RecencyDetail(flightLog: sampleFlightLog)
            }
            .previewDevice("iPhone 7")
            //.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
