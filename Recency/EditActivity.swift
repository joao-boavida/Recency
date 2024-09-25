//
//  EditActivity.swift
//  Recency
//
//  Created by Joao Boavida on 24/10/2020.
//

import SwiftUI

struct EditActivity: View {

    /// the activities database
    @ObservedObject var flightLog: FlightLog

    /// The activity before editing
    let originalActivity: FlightActivity

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

    @State private var showingConfirmationAlert = false
    @State private var showingErrorAlert = false

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
                Picker("Take-offs", selection: $takeoffsSelection) {
                    ForEach(pickerLabels, id: \.self) { label in
                        Text(label)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .accessibility(identifier: "takeoffsSegmentedPicker")
                Text("Landings")
                    .font(.headline)
                Picker("Landings", selection: $landingsSelection) {
                    ForEach(pickerLabels, id: \.self) { label in
                        Text(label)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .accessibility(identifier: "landingsSegmentedPicker")
            }
            Section {
                DatePicker("Date", selection: $activityDate, in: sixMonthsAgo ... inOneMonth, displayedComponents: .date)
            }
            Section {
                Button("Delete Activity") {
                    showingConfirmationAlert = true
                }.font(.headline)
                .foregroundColor(.red)
                .alert(isPresented: $showingConfirmationAlert) {
                    Alert(title: Text("Do you want to permanently delete this activity?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete")) {
                        do {
                            try flightLog.removeActivity(activity: originalActivity)
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            showingErrorAlert = true // this should never be reached as the original activity is retrieved from the database;
                        }
                    })
                }
                .accessibility(identifier: "deleteActivityButton")
            }
            Section {
                Button("Save Changes") {
                    let updatedActivity = FlightActivity(id: originalActivity.id, insertionDate: originalActivity.insertionDate, takeoffs: takeoffs, activityDate: activityDate, landings: landings)

                    do {
                        try flightLog.removeActivity(activity: originalActivity)
                        flightLog.addActivity(activity: updatedActivity)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        showingErrorAlert = true
                    }
                }
                .disabled(landings == 0 && takeoffs == 0)
                .font(.headline)
                .alert(isPresented: $showingErrorAlert) {
                    Alert(title: Text("This activity could not be found"), dismissButton: .default(Text("Okay")))
                }
                .accessibility(identifier: "saveChangesButton")
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .accessibility(identifier: "cancelButton")

            }
        }
        .navigationBarTitle("Edit Activity", displayMode: .inline)
        .onAppear {
            // load the initial state from the activity to be edited
            takeoffsSelection = String.takeOffsLandingsSelections(originalActivity.takeoffs)
            landingsSelection = String.takeOffsLandingsSelections(originalActivity.landings)
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
