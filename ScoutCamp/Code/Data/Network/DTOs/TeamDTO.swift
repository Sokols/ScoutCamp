//
//  TeamDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

struct TeamDTO: FirebaseModel {
    let id: String

    let userId: String?      // non-nullable for teams

    let troopId: String?     // if not null then it's troop
    let regimentId: String?  // if not null then it's regiment

    let name: String
}
