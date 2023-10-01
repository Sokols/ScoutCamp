//
//  Team.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Team: FirebaseModel, Identifiable {
    let id: String

    let userId: String?      // non-nullable for teams

    let troopId: String?     // if not null then it's troop
    let regimentId: String?  // if not null then it's regiment

    let name: String
}
