//
//  Assignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 30/04/2024.
//

import Foundation

struct Assignment: Hashable {
    let id: String

    let mainAssignmentGroupId: String
    let dependentOnAssignmentId: String?
    let assignmentType: String

    let description: String
    let maxPoints: Double
    let maxScoringValue: Double?
}

extension Assignment {
    func toDomain(
        teamAssignment: TeamCategorizationSheetAssignment?,
        groupAssignmentJunctions: [AssignmentGroupJunction],
        groups: [AssignmentGroup]
    ) -> AppAssignment? {
        guard let mainAssignmentGroup = groups.first(where: { $0.id == self.mainAssignmentGroupId }),
              let assignmentType = AppAssignment.AssignmentType(rawValue: self.assignmentType) else { return nil }

        var shares: [AppAssignment.AssignmentGroupShare]?
        if !groupAssignmentJunctions.isEmpty {
            shares = groupAssignmentJunctions.compactMap { junction in
                if let group = groups.first(where: { $0.id == junction.assignmentGroupId }) {
                    return AppAssignment.AssignmentGroupShare(
                        assignmentGroup: group,
                        percentageShare: junction.percentageShare ?? 1.0
                    )
                } else {
                    return nil
                }
            }.sorted(by: { $0.percentageShare > $1.percentageShare })
        }

        return AppAssignment(
            assignmentId: self.id,
            teamAssignmentId: teamAssignment?.id,
            mainAssignmentGroup: mainAssignmentGroup,
            assignmentType: assignmentType,
            assignmentGroupShares: shares,
            description: self.description,
            maxPoints: self.maxPoints,
            isCompleted: teamAssignment?.isCompleted ?? false,
            value: teamAssignment?.value ?? 0,
            maxScoringValue: self.maxScoringValue
        )
    }
}
