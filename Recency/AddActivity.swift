//
//  AddActivity.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

struct AddActivity: View {

    @ObservedObject var flightLog: FlightLog

    @State private var landings = 1
    @State private var takeoffs = 1
    @State private var takeoffDate = Date()
    @State private var landingDate = Date()

    @Environment(\.presentationMode) var presentationMode

    let pickerLabels = ["0", "1", "2", "3+"]

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
                    DatePicker("Date", selection: $takeoffDate, displayedComponents: .date)
                        //.labelsHidden()
                }
                Section {
                    Text("Landings")
                        .font(.headline)
                    Picker("Take-offs", selection: $landings) {
                        ForEach(0 ..< pickerLabels.count) {
                            Text("\(pickerLabels[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    DatePicker("Date", selection: $landingDate, displayedComponents: .date)
                        //.labelsHidden()
                }
                Section {
                    Button("Done") {
                        let activity = FlightActivity(takeoffs: takeoffs, takeoffDate: takeoffDate, landings: landings, landingDate: landingDate)

                        flightLog.data.append(activity)
                        presentationMode.wrappedValue.dismiss()

                    }
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
