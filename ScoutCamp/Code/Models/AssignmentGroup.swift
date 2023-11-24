//
//  AssignmentGroup.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

struct AssignmentGroup: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let order: Int
}

extension AssignmentGroup {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "name": name,
            "order": order
        ]

        return map.compactMapValues { $0 }
    }
}
