//
//  ValidityDetail.swift
//  Recency
//
//  Created by Joao Boavida on 16/11/2020.
//

import SwiftUI

/// This view shows separate take-off and landing validity in the upper part of the Recency Detail screen
struct ValidityDetail: View {

    let takeoffsValidityDate: Date
    let landingsValidityDate: Date

    let takeoffValidityStatus: Bool
    let landingValidityStatus: Bool

    var validImage: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 40))
    }

    var invalidImage: some View {
        Image(systemName: "xmark.octagon.fill")
            .font(.system(size: 40))
    }

    var body: some View {
        HStack {
            VStack {
                takeoffValidityStatus ? AnyView(validImage) : AnyView(invalidImage)
                Group {
                    Text("Takeoffs")
                    takeoffValidityStatus ? Text(formatDate(date: takeoffsValidityDate)) : Text("Expired")
                }.font(.title2)
                .padding(.leading, 10)
            }.foregroundColor(takeoffValidityStatus ? .green : .red)
            Spacer()
            VStack {
                landingValidityStatus ? AnyView(validImage) : AnyView(invalidImage)
                Group {
                    Text("Landings")
                    landingValidityStatus ? Text(formatDate(date: landingsValidityDate)) : Text("Expired")
                }.font(.title2)
                .padding(.trailing, 10)
            }.foregroundColor(landingValidityStatus ? .green : .red)
        }
    }

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

struct ValidityDetail_Previews: PreviewProvider {
    static var previews: some View {

        var components = DateComponents()

        components.year = 2020
        components.month = 12
        components.day = 30

        let date1 = Calendar.current.date(from: components)!

        return NavigationView {
            Form {
                Section {
                    ValidityDetail(takeoffsValidityDate: date1, landingsValidityDate: Date(), takeoffValidityStatus: true, landingValidityStatus: true)

                }
                Section {
                    ValidityDetail(takeoffsValidityDate: Date(), landingsValidityDate: Date(), takeoffValidityStatus: false, landingValidityStatus: false)
                }
            }
        }
        .previewDevice("iPhone 7")
        
    }
}
