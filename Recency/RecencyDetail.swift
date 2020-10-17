//
//  RecencyDetail.swift
//  Recency
//
//  Created by Joao Boavida on 13/10/2020.
//

import SwiftUI

/// This subview is a line of the activity log list
struct ActivityDetail: View {

    /// The activity to be displayed
    let activity: FlightActivity

    /// The formatted activity date
    var dateText: Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let description = dateFormatter.string(from: activity.activityDate)
        return Text(description)
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            dateText
            Spacer()
            Image(systemName: "arrow.up.forward.circle")
            Text("\(activity.takeoffs)")
            Image(systemName: "arrow.down.right.circle")
            Text("\(activity.landings)")
        }
        .font(.title3)
    }
}

/// Main view of the recency detail screen showing landing and take-off validity as well as an activity log
struct RecencyDetail: View {

    @ObservedObject var flightLog: FlightLog

    var takeOffLimitation: Date {
        flightLog.checkTakeoffRecency()
    }
    var landingLimitation: Date {
        flightLog.checkLandingRecency()
    }

    var takeoffLimitationText: Text {
        if takeOffLimitation >= Date() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let description = dateFormatter.string(from: takeOffLimitation)
            return Text("Takeoffs: \(description)")
        } else {
            return Text("Takeoffs not valid")
        }
    }

    var landingLimitationText: Text {

        if landingLimitation >= Date() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let description = dateFormatter.string(from: landingLimitation)
            return Text("Landings: \(description)")
        } else {
            return Text("Landings not valid")
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Takeoff and Landing Validity")) {
                HStack {
                    Spacer()
                    takeoffLimitationText
                        .font(.title3)
                    Spacer()
                }
                HStack {
                    Spacer()
                    landingLimitationText
                        .font(.title3)
                    Spacer()
                }

            }
            Section(header: Text("Activity log")) {
                ForEach(flightLog.data) { activity in
                    ActivityDetail(activity: activity)
                }
                .onDelete(perform: removeItems)
            }
        }
        .navigationBarTitle("Recency Detail") //already hosted on the navigation view of the parent view
        .navigationBarItems(trailing: EditButton())
    }

    /// Handles activity deletion from the data array
    /// - Parameter offsets: offsets from the line the user selected for deletion
    func removeItems(at offsets: IndexSet) {
        flightLog.data.remove(atOffsets: offsets)
    }
}

struct RecencyDetail_Previews: PreviewProvider {
    static var previews: some View {

        let sampleFlightLog = FlightLog(emptyLog: true)

        // referenceDate

        var components = DateComponents()
        components.year = 2020
        components.month = 10
        components.day = 13
        //components.calendar = .current

        let referenceDate = Calendar.current.date(from: components)!

        let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)

        // 3 days ago
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!

        let movement2 = FlightActivity(takeoffs: 1, activityDate: threeDaysAgo, landings: 1)

        // 30 days ago
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: referenceDate)!

        let movement3 = FlightActivity(takeoffs: 1, activityDate: thirtyDaysAgo, landings: 1)

        // 100 days ago
        let hundredDaysAgo = Calendar.current.date(byAdding: .day, value: -100, to: referenceDate)!

        let movement4 = FlightActivity(takeoffs: 1, activityDate: hundredDaysAgo, landings: 1)

        sampleFlightLog.data.append(movement1)
        sampleFlightLog.data.append(movement2)
        sampleFlightLog.data.append(movement3)
        sampleFlightLog.data.append(movement4)

        return
            NavigationView {
                RecencyDetail(flightLog: sampleFlightLog)
            }
    }
}
