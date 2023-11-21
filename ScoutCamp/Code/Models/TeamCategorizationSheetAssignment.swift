//
//  TeamCategorizationSheetAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct TeamCategorizationSheetAssignment: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let assignmentId: String
    let teamCategorizationSheetId: String

    var isCompleted: Bool
    var value: Int
}

extension TeamCategorizationSheetAssignment {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "assignmentId": assignmentId,
            "teamCategorizationSheetId": teamCategorizationSheetId,
            "isCompleted": isCompleted,
            "value": value
        ]

        return map.compactMapValues { $0 }
    }
}
