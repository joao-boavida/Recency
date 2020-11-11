//
//  WelcomeSheet.swift
//  Recency
//
//  Created by Joao Boavida on 17/10/2020.
//

import SwiftUI

/// This view is the welcome screen shown on first launch
struct WelcomeSheet: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {

        NavigationView {
            VStack(alignment: .center) {
                Image("AppStore")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .clipShape(Capsule(style: .continuous))
                Spacer()
                Text("Welcome!")
                    .font(.largeTitle)
                //Spacer()
                Text("""
This app helps you keep track of your compliance with EASA-FCL.060 / FAA 14 CFR 61.57 Recent Experience requirements by logging your latest takeoffs and landings.

To begin add your most recent flights and simulator sessions by pressing "Add Activity".

Fly safe!
""")
                    .padding()
                Spacer()
                Button("Get Started") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.title)
                .padding()
                .accessibility(identifier: "getStartedButton")
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }

}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet()
            //.environment(\.colorScheme, .dark)
    }
}
