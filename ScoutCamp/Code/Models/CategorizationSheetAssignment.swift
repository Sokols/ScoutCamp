//
//  CategorizationSheetAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct CategorizationSheetAssignment: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categorizationSheetId: String
    let assignmentId: String
}

extension CategorizationSheetAssignment {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categorizationSheetId": categorizationSheetId,
            "assignmentId": assignmentId
        ]

        return map.compactMapValues { $0 }
    }
}
