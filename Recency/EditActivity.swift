//
//  EditActivity.swift
//  Recency
//
//  Created by Joao Boavida on 24/10/2020.
//

import SwiftUI

struct EditActivity: View {

    /// the FlightLog which will be created for insertion
    @ObservedObject var flightLog: FlightLog

    let originalActivity: FlightActivity

    @State private var landings = 1
    @State private var takeoffs = 1
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
                Button("Save Changes") {
                    let activity = FlightActivity(id: originalActivity.id, insertionDate: originalActivity.insertionDate, takeoffs: takeoffs, activityDate: activityDate, landings: landings)

                    let indexToRemove = flightLog.data.firstIndex(where: { $0.id == originalActivity.id})

                    if let indexToRemove = indexToRemove {
                        flightLog.data.remove(at: indexToRemove)
                        flightLog.addActivity(activity: activity)
                    }
                    presentationMode.wrappedValue.dismiss()

                }
                .disabled(landings == 0 && takeoffs == 0)
                .font(.headline)
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.red)

            }

        }
        .navigationBarTitle("Edit Activity")
        .onAppear {
            //load the initial state from the activity to be edited
            takeoffs = originalActivity.takeoffs
            landings = originalActivity.landings
            activityDate = originalActivity.activityDate
        }
    }

}

struct EditActivity_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditActivity(flightLog: FlightLog(), originalActivity: FlightActivity(takeoffs: 2, activityDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, landings: 3))
        }
    }
}
