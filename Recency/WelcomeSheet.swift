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
This app helps you keep track of your takeoffs and landings to make sure you comply with EASA-FCL.060 Recent Experience requirements.

To begin add your most recent flights and sim sessions by pressing "Add Activity".

Fly safe!
""")
                    .padding()
                Spacer()
                Button("Get Started") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.title)
                .padding()
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
