//
//  CategorizationAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

enum AssignmentType: String {
    case numeric
    case boolean
}

struct Assignment: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categoryId: String?
    let mainAssignmentGroupId: String
    let categorizationSheetId: String
    let assignmentType: String

    let description: String
    let maxPoints: Int
    let maxScoringValue: Decimal?

    let minimums: [String: Decimal]? // [categoryId: minPoints]
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
