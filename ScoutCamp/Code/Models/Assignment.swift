//
//  CategorizationAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Assignment: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categoryId: String?
    let mainAssignmentGroupId: String
    let categorizationSheetId: String
    let assignmentType: String

    let description: String
    let maxPoints: Int
    let maxScoringValue: Int?

    let minimums: [String: Int]? // [categoryId: minPoints]
}

extension Assignment {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categoryId": categoryId,
            "mainAssignmentGroupId": mainAssignmentGroupId,
            "categorizationSheetId": categorizationSheetId,
            "assignmentType": assignmentType,
            "description": description,
            "maxPoints": maxPoints,
            "maxScoringValue": maxScoringValue,
            "minimums": minimums
        ]

        return map.compactMapValues { $0 }
    }
}
