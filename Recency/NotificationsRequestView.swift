//
//  NotificationsRequestView.swift
//  Recency
//
//  Created by Joao Boavida on 22/11/2020.
//

import SwiftUI

/// This view is presented as a sheet and asks the user for their authorisation to send local notifications, storing the answer in the flightLog. Only a positive answer will produce an authorisation request from apple's user notification framework.
struct NotificationsRequestView: View {

    @ObservedObject var flightLog: FlightLog

    @Environment(\.presentationMode) var presentationMode

    /// The description text used in this view
    var bodyText = """
If you allow notifications we will alert you once when there are 14 days left until your current recency date and once again on the expiry date.
"""

    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack(alignment: .center) {
                    Spacer()
                    BadgedAppIcon(frameLength: geo.size.width/2)
                    Text("Would you like notifications?")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text(bodyText)
                        .padding()
                    Group {
                        Button(action: {
                            flightLog.localNotificationPreferences = .allowed
                            // if the user allows notifications schedule them straight away! this method will trigger apple's authorisation request.
                            NotificationsManager.scheduleNotificationsFromRecencyDate(recencyDate: flightLog.recencyValidity)

                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Yes, notify me")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .clipShape(Capsule())
                        })

                        Button("No") {

                            flightLog.localNotificationPreferences = .denied

                            presentationMode.wrappedValue.dismiss()
                        }.padding()

                        Button("Maybe later") {
                            //maybe later actions
                            flightLog.localNotificationPreferences = .maybeLater
                            presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }.font(.headline)
                    Spacer()
                }.navigationBarHidden(true)
            }
        }
    }
}

struct NotificationsRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsRequestView(flightLog: FlightLog(emptyLog: true))
            //.preferredColorScheme(.dark)
    }
}
