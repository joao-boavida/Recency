//
//  String+NrTakeoffsLandings.swift
//  Recency
//
//  Created by João Boavida on 25/09/2024.
//

import Foundation

extension String {

    /// A converter to the actual number of take-offs or landings in the picker used in this app
    var numberOfTakeoffsOrLandings: Int {
        if self == "3+" {
            3
        } else {
            Int(self) ?? 0
        }
    }

    /// The picker option string for a given number of takeoffs or landings
    /// - Parameter actualNumber: the number of takeoffs or landings
    /// - Returns: the picker option string
    static func takeOffsLandingsSelections(_ actualNumber: Int) -> String {
        guard actualNumber >= 0 else { return "0" }

        if actualNumber >= 3 {
            return "3+"
        } else {
            return String(actualNumber)
        }
    }
}
