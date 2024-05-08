//
//  TeamDTO+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension TeamDTO {
    func toDomain() -> Team {
        return Team.init(
            id: id,
            userId: userId,
            troopId: troopId,
            regimentId: regimentId,
            name: name
        )
    }
}

extension TeamDTO {
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
}

extension Team {
    func toDropdownOption() -> DropdownOption {
        return DropdownOption(key: id, value: name)
    }
}
