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

    var bodyText = """
If you allow notifications we will alert you once when there are 14 days left until your current recency date and once again on the expiring date.
"""

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                BadgedAppIcon(frameLength: 200)
                    .padding(.top)
                Text("Would you like notifications?")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Text(bodyText)
                    .padding()
                Group {
                    Button(action: {
                        flightLog.localNotificationPreferences = .allowed
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
                }.font(.headline)
                Spacer(minLength: 30)
            }.navigationBarHidden(true)
        }
    }
}

struct NotificationsRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsRequestView(flightLog: FlightLog(emptyLog: true))
            //.preferredColorScheme(.dark)
    }
}
