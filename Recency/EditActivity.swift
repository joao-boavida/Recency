//
//  EditActivity.swift
//  Recency
//
//  Created by Joao Boavida on 24/10/2020.
//

import SwiftUI

struct EditActivity: View {

    enum ActiveAlert: Identifiable {
        case confirmationAlert
        case errorAlert

        var id: UUID {
            UUID()
        }
    }

    /// the activities database
    @ObservedObject var flightLog: FlightLog

    /// The activity before editing
    let originalActivity: FlightActivity

    @State private var landings = 1
    @State private var takeoffs = 1
    @State private var activityDate = Date()

    @State private var activeAlert: ActiveAlert?
    /*@State private var showingConfirmationAlert = false
    @State private var showingErrorAlert = false*/

    /// used to make the view dismiss itself
    @Environment(\.presentationMode) var presentationMode

    let pickerLabels = ["0", "1", "2", "3+"]

    let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? .distantPast
    let inOneMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? .distantFuture

    let errorAlert = Alert(title: Text("This activity could not be found"), dismissButton: .default(Text("Okay")))

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
                Button("Delete Activity") {
                    //showingConfirmationAlert = true
                    activeAlert = .confirmationAlert
                }.font(.headline)
                .foregroundColor(.red)
            }
            Section {
                Button("Save Changes") {
                    let updatedActivity = FlightActivity(id: originalActivity.id, insertionDate: originalActivity.insertionDate, takeoffs: takeoffs, activityDate: activityDate, landings: landings)

                    do {
                        try flightLog.removeActivity(activity: originalActivity)
                        flightLog.addActivity(activity: updatedActivity)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        //showingErrorAlert = true
                        activeAlert = .errorAlert
                    }
                }
                .disabled(landings == 0 && takeoffs == 0)
                .font(.headline)
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }

            }
        }
        .alert(item: $activeAlert) { item in
            switch item {
            case .confirmationAlert:
                return Alert(title: Text("Do you want to permanently delete this activity?"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Delete")) {
                    do {
                        try flightLog.removeActivity(activity: originalActivity)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        //showingErrorAlert = true // this should never be reached
                        activeAlert = .errorAlert
                    }
                })
            case .errorAlert:
                return Alert(title: Text("This activity could not be found"), dismissButton: .default(Text("Okay")))
            }
        }
        .navigationBarTitle("Edit Activity", displayMode: .inline)
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
