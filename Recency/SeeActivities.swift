//
//  SeeActivities.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

struct ActivityDetail: View {
    let activity: FlightActivity

    var dateText: Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let description = dateFormatter.string(from: activity.takeoffDate)
        return Text(description)
    }

    var body: some View {
        HStack(alignment: .center) {
            dateText
            Image(systemName: "arrow.up.forward.circle")
            Text("\(activity.takeoffs)")
            Image(systemName: "arrow.down.right.circle")
            Text("\(activity.landings)")
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}

struct SeeActivities: View {

    @ObservedObject var flightLog: FlightLog

    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationView {
            Form {
                ForEach(flightLog.data) { activity in
                    ActivityDetail(activity: activity)
                }
                .onDelete(perform: removeItems)
            }

            .navigationBarTitle("Flight Activities")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }

    }

    func removeItems(at offsets: IndexSet) {
        flightLog.data.remove(atOffsets: offsets)
    }
}

struct SeeActivities_Previews: PreviewProvider {
    static var previews: some View {

        let sampleFlightLog = FlightLog()


        // referenceDate

        var components = DateComponents()
        components.year = 2020
        components.month = 10
        components.day = 13
        //components.calendar = .current

        let referenceDate = Calendar.current.date(from: components)!

        let movement1 = FlightActivity(takeoffs: 1, takeoffDate: referenceDate, landings: 1, landingDate: referenceDate)

        // 3 days ago
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!

        let movement2 = FlightActivity(takeoffs: 1, takeoffDate: threeDaysAgo, landings: 1, landingDate: threeDaysAgo)

        // 30 days ago
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: referenceDate)!

        let movement3 = FlightActivity(takeoffs: 1, takeoffDate: thirtyDaysAgo, landings: 1, landingDate: thirtyDaysAgo)

        // 100 days ago
        let hundredDaysAgo = Calendar.current.date(byAdding: .day, value: -100, to: referenceDate)!

        let movement4 = FlightActivity(takeoffs: 1, takeoffDate: hundredDaysAgo, landings: 1, landingDate: hundredDaysAgo)


        sampleFlightLog.data.append(movement1)
        sampleFlightLog.data.append(movement2)
        sampleFlightLog.data.append(movement3)
        sampleFlightLog.data.append(movement4)

        return SeeActivities(flightLog: sampleFlightLog)
    }
}
