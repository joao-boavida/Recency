//
//  AddActivity.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

/// This view is presented as a sheet to add activities to the log
struct AddActivity: View {

    /// the FlightLog which will be created for insertion
    @ObservedObject var flightLog: FlightLog

    /// The selection in the landings picker
    @State private var landingsSelection = "1"

    /// The selection in the takeoffs picker
    @State private var takeoffsSelection = "1"

    /// The number of landings
    var landings: Int {
        landingsSelection.numberOfTakeoffsOrLandings
    }

    /// The number of takeoffs
    var takeoffs: Int {
        takeoffsSelection.numberOfTakeoffsOrLandings
    }

    @State private var activityDate = Date()

    /// used to make the view dismiss itself
    @Environment(\.presentationMode) var presentationMode

    let pickerLabels = ["0", "1", "2", "3+"]

    let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? .distantPast
    let inOneMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? .distantFuture

    var body: some View {
        Form {
            Section {
                Text("Take-offs")
                    .font(.headline)
                Picker("Take-offs", selection: $takeoffsSelection) {
                    ForEach(pickerLabels, id: \.self) { label in
                        Text(label)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .accessibility(identifier: "takeOffPicker")
                Text("Landings")
                    .font(.headline)
                Picker("Landings", selection: $landingsSelection) {
                    ForEach(pickerLabels, id: \.self) { label in
                        Text(label)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .accessibility(identifier: "landingPicker")
            }
            Section {
                DatePicker("Date", selection: $activityDate, in: sixMonthsAgo ... inOneMonth, displayedComponents: .date)
                    .accessibility(identifier: "datePicker")
            }
            Section {
                Button("Done") {
                    let activity = FlightActivity(takeoffs: takeoffs, activityDate: activityDate, landings: landings)

                    flightLog.addActivity(activity: activity)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(landings == 0 && takeoffs == 0)
                .font(.headline)
                .accessibility(identifier: "doneButton")

                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.red)
                .accessibility(identifier: "cancelButton")
            }
        }
        .navigationBarTitle("Add Activity")
    }
}

struct AddActivity_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddActivity(flightLog: FlightLog())
                .environment(\.colorScheme, .dark)
        }

    }
}
