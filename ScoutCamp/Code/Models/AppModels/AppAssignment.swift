//
//  AppAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 22/11/2023.
//

import Foundation

struct AppAssignment: Hashable {
    let assignmentId: String
    let teamAssignmentId: String?

    let category: Category?
    let mainAssignmentGroup: AssignmentGroup
    let assignmentType: AssignmentType
    let assignmentGroups: [AssignmentGroup: Double] // [assignmentGroup: percentageShare]

    let description: String
    let maxPoints: Int
    let minimums: [Category: Decimal]? // [category: minPoints]

    var isCompleted: Bool = false
    var value: Decimal = 0
    var maxScoringValue: Decimal?
}

extension AppAssignment {
    var isValid: Bool {
        return isValueValid
    }

    var isValueValid: Bool {
        if let maxScoringValue {
            return value <= maxScoringValue
        }
        return true
    }

    var errorPrompt: String? {
        if let maxScoringValue, !isValueValid {
            return "Max value is \(maxScoringValue)"
        }
        return nil
    }
}

extension AppAssignment {
    static func from(
        assignment: Assignment,
        teamAssignment: TeamCategorizationSheetAssignment?,
        groupAssignmentJunctions: [AssignmentGroupAssignmentJunction]
    ) -> AppAssignment {
        let category = assignment.categoryId.flatMap { CategoriesService.categoryFor(id: $0) }
        let mainAssignmentGroup = AssignmentGroupsService.getAssignmentGroupFor(id: assignment.mainAssignmentGroupId)
        let minimums = [Category: Decimal](uniqueKeysWithValues: (assignment.minimums ?? [:]).compactMap {
            (key, value) in (CategoriesService.categoryFor(id: key)!, value)
        })
        let assignmentGroups = [AssignmentGroup: Double](uniqueKeysWithValues: (groupAssignmentJunctions).compactMap {
            value in (AssignmentGroupsService.getAssignmentGroupFor(id: value.assignmentGroupId)!, value.percentageShare ?? 1)
        })

        return AppAssignment(
            assignmentId: assignment.id,
            teamAssignmentId: teamAssignment?.id,
            category: category,
            mainAssignmentGroup: mainAssignmentGroup!,
            assignmentType: AssignmentType(rawValue: assignment.assignmentType)!,
            assignmentGroups: assignmentGroups,
            description: assignment.description,
            maxPoints: assignment.maxPoints,            
            minimums: minimums,
            isCompleted: teamAssignment?.isCompleted ?? false,
            value: teamAssignment?.value ?? 0,
            maxScoringValue: assignment.maxScoringValue
        )
    }
}

extension AppAssignment {
    func toTeamSheetAssignmentData(from teamCategorizationSheetId: String) -> [String: Any] {
        var map: [String: Any] = [
            "assignmentId": assignmentId,
            "teamCategorizationSheetId": teamCategorizationSheetId
        ]
        if let teamAssignmentId {
            map["id"] = teamAssignmentId
        }
        switch assignmentType {
        case .boolean:
            map["isCompleted"] = isCompleted
        case .numeric:
            map["value"] = value
        }

        return map
    }
}
