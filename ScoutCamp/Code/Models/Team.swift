//
//  Team.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Foundation

struct Team: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let userId: String?      // non-nullable for teams

    let troopId: String?     // if not null then it's troop
    let regimentId: String?  // if not null then it's regiment

    let name: String
}

extension Team {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "userId": userId,
            "troopId": troopId,
            "regimentId": regimentId,
            "name": name
        ]

        return map.compactMapValues { $0 }
    }

    func toDropdownOption() -> DropdownOption {
        return DropdownOption(key: id, value: name)
    }
}
