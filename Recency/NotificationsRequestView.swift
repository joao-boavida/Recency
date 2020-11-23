//
//  NotificationsRequestView.swift
//  Recency
//
//  Created by Joao Boavida on 22/11/2020.
//

import SwiftUI

struct NotificationsRequestView: View {

    @ObservedObject var flightLog: FlightLog

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("Would you like notifications?")
                    .font(.title)
                Group {
                    Button("Yes, notify me") {
                        flightLog.localNotificationPreferences = .allowed
                        NotificationsManager.scheduleNotificationsFromRecencyDate(recencyDate: flightLog.recencyValidity)
                        // yes actions

                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                    Button("No") {
                        // no actions
                        flightLog.localNotificationPreferences = .denied

                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                    Button("Maybe later") {
                        //maybe later actions
                        flightLog.localNotificationPreferences = .maybeLater
                        presentationMode.wrappedValue.dismiss()
                    }
                }.font(.headline)
                Spacer()
            }
        }
    }
}

struct NotificationsRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsRequestView(flightLog: FlightLog(emptyLog: true))
    }
}
