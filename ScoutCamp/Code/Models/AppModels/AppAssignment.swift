//
//  AppAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 22/11/2023.
//

import Foundation

struct AppAssignment: Hashable {
    let assignmentId: String

    let category: Category?
    let mainAssignmentGroup: AssignmentGroup
    let assignmentType: AssignmentType

    let assignmentGroups: [AssignmentGroup: Double] // [assignmentGroup: percentageShare]

    let description: String
    let maxPoints: Int
    let maxScoringValue: Int?

    let minimums: [Category: Int]? // [category: minPoints]

    var isCompleted: Bool = false
    var value: String = ""

    var intValue: Int { Int(value) ?? 0 }
}

extension AppAssignment {
    static func from(
        assignment: Assignment,
        teamAssignment: TeamCategorizationSheetAssignment?,
        groupAssignmentJunctions: [AssignmentGroupAssignmentJunction]
    ) -> AppAssignment {
        let category = assignment.categoryId.flatMap { CategoriesService.categoryFor(id: $0) }
        let mainAssignmentGroup = AssignmentGroupsService.getAssignmentGroupFor(id: assignment.mainAssignmentGroupId)
        let minimums = [Category: Int](uniqueKeysWithValues: (assignment.minimums ?? [:]).compactMap {
            (key, value) in (CategoriesService.categoryFor(id: key)!, value)
        })
        let assignmentGroups = [AssignmentGroup: Double](uniqueKeysWithValues: (groupAssignmentJunctions).compactMap {
            value in (AssignmentGroupsService.getAssignmentGroupFor(id: value.assignmentGroupId)!, value.percentageShare ?? 1)
        })

        return AppAssignment(
            assignmentId: assignment.id,
            category: category,
            mainAssignmentGroup: mainAssignmentGroup!,
            assignmentType: AssignmentType(rawValue: assignment.assignmentType)!,
            assignmentGroups: assignmentGroups,
            description: assignment.description,
            maxPoints: assignment.maxPoints,
            maxScoringValue: assignment.maxScoringValue,
            minimums: minimums,
            isCompleted: teamAssignment?.isCompleted ?? false,
            value: teamAssignment?.value?.description ?? ""
        )
    }
}
