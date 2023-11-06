//
//  AssignmentGroupAssignmentJunction.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 05/11/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct AssignmentGroupAssignmentJunction: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let assignmentGroupId: String
    let assignmentId: String

    let percentageShare: Double?
}

extension AssignmentGroupAssignmentJunction {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "assignmentGroupId": assignmentGroupId,
            "assignmentId": assignmentId,
            "percentageShare": percentageShare
        ]

        return map.compactMapValues { $0 }
    }
}
