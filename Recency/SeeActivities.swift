//
//  SeeActivities.swift
//  Recency
//
//  Created by Joao Boavida on 12/10/2020.
//

import SwiftUI

struct SeeActivities: View {

    @ObservedObject var flightLog: FlightLog

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List { // temporary for dev
                ForEach(flightLog.data) { activity in
                    Text("\(activity.takeoffDate.description)")
                    Text("\(activity.takeoffs)")
                }
            }
            .navigationBarTitle("Flight Activities")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }

    }
}

struct SeeActivities_Previews: PreviewProvider {
    static var previews: some View {
        SeeActivities(flightLog: FlightLog())
    }
}
