//
//  RecencyDetail.swift
//  Recency
//
//  Created by Joao Boavida on 13/10/2020.
//

import SwiftUI

struct DetailValidityView: View {

    let takeoffsValidityDate: Date
    let landingsValidityDate: Date

    let takeoffValidityStatus: Bool
    let landingValidityStatus: Bool

    var validImage: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 40))
    }

    var invalidImage: some View {
        Image(systemName: "xmark.octagon.fill")
            .font(.system(size: 40))
    }

    var body: some View {
        HStack {
            Spacer()
            VStack {
                takeoffValidityStatus ? AnyView(validImage) : AnyView(invalidImage)
                Group {
                    Text("Takeoffs")
                    takeoffValidityStatus ? Text(formatDate(date: takeoffsValidityDate)) : Text("Expired")
                }.font(.title2)
            }.foregroundColor(takeoffValidityStatus ? .green : .red)
            Spacer(minLength: 70)
            VStack {
                landingValidityStatus ? AnyView(validImage) : AnyView(invalidImage)
                Group {
                    Text("Landings")
                    landingValidityStatus ? Text(formatDate(date: landingsValidityDate)) : Text("Expired")
                }.font(.title2)
            }.foregroundColor(landingValidityStatus ? .green : .red)
            Spacer()
        }
    }

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

/// This subview is a line of the activity log list
struct ActivityDetail: View {

    @ObservedObject var flightLog: FlightLog

    let movementCellWidth: CGFloat
    /// The activity to be displayed
    let activity: FlightActivity

    var body: some View {
        NavigationLink(destination: EditActivity(flightLog: flightLog, originalActivity: activity)) {
            HStack(alignment: .lastTextBaseline) {
                Text(activity.formattedDate)
                Spacer()
                Group {
                    Image(systemName: "arrow.up.forward.circle")
                    Text("\(activity.takeoffs)")
                    Image(systemName: "arrow.down.right.circle")
                    Text("\(activity.landings)")
                }
                .frame(width: movementCellWidth)

            }
            .font(.title3)
        }.accessibility(identifier: activity.shortDescription)
    }
}

/// Main view of the recency detail screen showing landing and take-off validity as well as an activity log
struct RecencyDetail: View {

    @ObservedObject var flightLog: FlightLog

    var takeoffLimitationText: Text {
        if flightLog.takeoffRecencyValidity >= Date() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let description = dateFormatter.string(from: flightLog.takeoffRecencyValidity)
            return Text("Takeoffs: \(description)")
        } else {
            return Text("Takeoffs not valid")
        }
    }

    var landingLimitationText: Text {

        if flightLog.landingRecencyValidity >= Date() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let description = dateFormatter.string(from: flightLog.landingRecencyValidity)
            return Text("Landings: \(description)")
        } else {
            return Text("Landings not valid")
        }
    }

    var body: some View {
        GeometryReader { geo in
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
                    if flightLog.data.isEmpty {
                        Text("There are no activities to display.")
                    } else {
                        ForEach(flightLog.data) { activity in
                            ActivityDetail(flightLog: flightLog, movementCellWidth: geo.size.width/20, activity: activity)
                        }
                        .onDelete(perform: removeItems)
                    }
                }
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
        components.day = 13
        //components.calendar = .current

        let referenceDate = Calendar.current.date(from: components)!

        let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)

        // 3 days ago
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!

        let movement2 = FlightActivity(takeoffs: 2, activityDate: threeDaysAgo, landings: 1)

        // 30 days ago
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: referenceDate)!

        let movement3 = FlightActivity(takeoffs: 1, activityDate: thirtyDaysAgo, landings: 3)

        // 100 days ago
        let hundredDaysAgo = Calendar.current.date(byAdding: .day, value: -100, to: referenceDate)!

        let movement4 = FlightActivity(takeoffs: 1, activityDate: hundredDaysAgo, landings: 1)

        sampleFlightLog.addActivity(activity: movement1)
        sampleFlightLog.addActivity(activity: movement2)
        sampleFlightLog.addActivity(activity: movement3)
        sampleFlightLog.addActivity(activity: movement4)

        /*return
            NavigationView {
                RecencyDetail(flightLog: sampleFlightLog)
            }*/

        return
            Group {
                NavigationView {
                    Form {
                        Section(header: Text("SECTION TITLE")) {
                            DetailValidityView(takeoffsValidityDate: Date.distantPast, landingsValidityDate: Date.distantFuture, takeoffValidityStatus: false, landingValidityStatus: true)
                        }
                    }
                }
                NavigationView {
                    Form {
                        Section(header: Text("SECTION TITLE")) {
                            DetailValidityView(takeoffsValidityDate: Date.distantPast, landingsValidityDate: Date.distantFuture, takeoffValidityStatus: false, landingValidityStatus: true)
                        }
                    }
                }
                .preferredColorScheme(.dark)
            }
    }

}
