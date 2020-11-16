//
//  ActivityDetail.swift
//  Recency
//
//  Created by Joao Boavida on 16/11/2020.
//

import SwiftUI

/// This subview is a line of the activity log list
struct ActivityDetail: View {

    @ObservedObject var flightLog: FlightLog

    let movementCellWidth: CGFloat
    /// The activity to be displayed
    let activity: FlightActivity

    var body: some View {
        NavigationLink(destination: EditActivity(flightLog: flightLog, originalActivity: activity)) {
            HStack(alignment: .lastTextBaseline) {
                Text(activity.formattedDate)
                Spacer()
                Group {
                    Image(systemName: "arrow.up.forward.circle")
                    Text("\(activity.takeoffs)")
                    Image(systemName: "arrow.down.right.circle")
                    Text("\(activity.landings)")
                }
                .frame(width: movementCellWidth)

            }
            .font(.title3)
        }.accessibility(identifier: activity.shortDescription)
    }
}

/*
struct ActivityDetail_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetail(flightLog: <#T##FlightLog#>, movementCellWidth: <#T##CGFloat#>, activity: <#T##FlightActivity#>)
    }
}*/
