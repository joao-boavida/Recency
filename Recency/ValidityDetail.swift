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

    /// Obtained from a geometry reader on the parent view; one day it would be interesting to try and create own geo reader
    let screenWidth: CGFloat

    /// The amount of padding to apply on the take off and landing validity indicators to make the view adapt to varying screen widths. Formula guessed by trial and error. At time of writing, iPhone display sizes in points: 320 (iPhone SE 1st gen) to 428 (iPhone 12 Pro Max).
    var paddingAmount: CGFloat {
        10 + 30 * (screenWidth - 320)/(428-320)
    }

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
                Group {
                    takeoffValidityStatus ? AnyView(validImage) : AnyView(invalidImage)
                    Text("Takeoffs")
                    takeoffValidityStatus ? Text(formatDate(date: takeoffsValidityDate)) : Text("Expired")
                }.font(.title2)
                .padding(.leading, paddingAmount)
            }.foregroundColor(takeoffValidityStatus ? .green : .red)
            Spacer()
            VStack {
                Group {
                    landingValidityStatus ? AnyView(validImage) : AnyView(invalidImage)
                    Text("Landings")
                    landingValidityStatus ? Text(formatDate(date: landingsValidityDate)) : Text("Expired")
                }.font(.title2)
                .padding(.trailing, paddingAmount)
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
            GeometryReader { geo in
                Form {
                    Section {
                        ValidityDetail(takeoffsValidityDate: date1, landingsValidityDate: Date(), takeoffValidityStatus: true, landingValidityStatus: true, screenWidth: geo.size.width)

                    }
                    Section {
                        ValidityDetail(takeoffsValidityDate: Date(), landingsValidityDate: Date(), takeoffValidityStatus: false, landingValidityStatus: false, screenWidth: geo.size.width)
                    }
                }
            }

        }

    }
}
