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

    let categorizationSheetAssignmentId: String
    let teamCategorizationSheetId: String

    let isCompleted: Bool?
    let value: Int?
}

extension TeamCategorizationSheetAssignment {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categorizationSheetAssignmentId": categorizationSheetAssignmentId,
            "teamCategorizationSheetId": teamCategorizationSheetId,
            "isCompleted": isCompleted,
            "value": value
        ]

        return map.compactMapValues { $0 }
    }
}
