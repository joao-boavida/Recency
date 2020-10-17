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

    @State private var landings = 1
    @State private var takeoffs = 1
    @State private var activityDate = Date()

    /// used to make the view dismiss itself
    @Environment(\.presentationMode) var presentationMode

    let pickerLabels = ["0", "1", "2", "3+"]

    let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? .distantPast
    let inOneMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? .distantFuture

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Take-offs")
                        .font(.headline)
                    Picker("Take-offs", selection: $takeoffs) {
                        ForEach(0 ..< pickerLabels.count) {
                            Text("\(pickerLabels[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Text("Landings")
                        .font(.headline)
                    Picker("Take-offs", selection: $landings) {
                        ForEach(0 ..< pickerLabels.count) {
                            Text("\(pickerLabels[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    DatePicker("Date", selection: $activityDate, in: sixMonthsAgo ... inOneMonth, displayedComponents: .date)
                }
                Section {
                    Button("Done") {
                        let activity = FlightActivity(takeoffs: takeoffs, activityDate: activityDate, landings: landings)

                        flightLog.addActivity(activity: activity)
                        presentationMode.wrappedValue.dismiss()

                    }
                    .disabled(landings == 0 && takeoffs == 0)
                    .font(.headline)
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.foregroundColor(.red)

                }

            }
            .navigationBarTitle("Add Activity")
        }
    }
}

struct AddActivity_Previews: PreviewProvider {
    static var previews: some View {
        AddActivity(flightLog: FlightLog())
    }
}
