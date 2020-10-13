//
//  RecencyDetail.swift
//  Recency
//
//  Created by Joao Boavida on 13/10/2020.
//

import SwiftUI

struct RecencyDetail: View {

    var takeOffLimitation: Date
    var landingLimitation: Date

    var takeoffLimitationText: Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let description = dateFormatter.string(from: takeOffLimitation)
        return Text("Takeoffs valid until \(description)")
    }

    var landingLimitationText: Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let description = dateFormatter.string(from: landingLimitation)
        return Text("Landings valid until \(description)")
    }

    var body: some View {
        NavigationView {
            Form {
                takeoffLimitationText
                landingLimitationText
            }
            .navigationBarTitle("Recency Detail")
        }
    }
}

struct RecencyDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecencyDetail(takeOffLimitation: Date(), landingLimitation: Date())
    }
}
