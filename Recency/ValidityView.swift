//
//  ValidityView.swift
//  Recency
//
//  Created by Joao Boavida on 16/11/2020.
//

import SwiftUI

/// This view shows the validity status on the main screen, providing a navigation link to the recency detail screen if appropriate
struct ValidityView: View {

    let validityDate: Date

    let recencyValid: Bool

    let destination: AnyView

    var formattedRecencyValidity: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: validityDate)
    }

    var body: some View {
        if recencyValid {
            NavigationLink(destination: destination) {
                Section {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                        Spacer()
                        VStack {
                            Text("Recency OK")
                                .font(.largeTitle)
                            Text("until \(formattedRecencyValidity)")
                                .font(.title2)
                        }
                        Spacer()
                    }.frame(minHeight: 100)
                }
            }
            .foregroundColor(.green)
        } else {
            Section {
                HStack {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.system(size: 40))
                    Spacer()
                    VStack {
                        Text("Recency Expired")
                            .font(.largeTitle)
                    }
                    Spacer()
                }.frame(minHeight: 100)
            }
            .foregroundColor(.red)

        }

    }

}
struct ValidityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    ValidityView(validityDate: Date(), recencyValid: true, destination: AnyView(Text("Destination View")))
                    ValidityView(validityDate: Date(), recencyValid: false, destination: AnyView(Text("Destination View")))
                }
            }
            NavigationView {
                Form {
                    ValidityView(validityDate: Date(), recencyValid: true, destination: AnyView(Text("Destination View")))
                    ValidityView(validityDate: Date(), recencyValid: false, destination: AnyView(Text("Destination View")))
                }
            }
            .preferredColorScheme(.dark)
        }

    }
}
