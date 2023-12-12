//
//  CategorizationPeriod.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct CategorizationPeriod: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
}

extension CategorizationPeriod {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "name": name
        ]

        return map.compactMapValues { $0 }
    }
}
