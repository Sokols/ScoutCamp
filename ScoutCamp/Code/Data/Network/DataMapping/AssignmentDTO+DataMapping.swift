//
//  Assignment+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation
import DGCharts

extension AssignmentDTO {
    func toDomain(
        teamAssignment: TeamCategorizationSheetAssignment?,
        groupAssignmentJunctions: [AssignmentGroupAssignmentJunctionDTO],
        groups: [AssignmentGroup]
    ) -> Assignment? {
        guard let mainAssignmentGroup = groups.first(where: { $0.id == self.mainAssignmentGroupId }),
              let assignmentType = Assignment.AssignmentType(rawValue: self.assignmentType) else { return nil }

        var shares: [Assignment.AssignmentGroupShare]?
        if !groupAssignmentJunctions.isEmpty {
            shares = groupAssignmentJunctions.compactMap { junction in
                if let group = groups.first(where: { $0.id == junction.assignmentGroupId }) {
                    return Assignment.AssignmentGroupShare(
                        assignmentGroup: group,
                        percentageShare: junction.percentageShare ?? 1.0
                    )
                } else {
                    return nil
                }
            }.sorted(by: { $0.percentageShare > $1.percentageShare })
        }

        return Assignment(
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

extension Assignment {
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

    func dataEntries() -> [PieChartDataEntry] {
        let entries = (assignmentGroupShares ?? []).map {
            let isPercent = getPoints() == 0
            var value = $0.percentageShare
            if !isPercent {
                value *= self.maxPoints
            }
            return PieChartDataEntry(
                value: value,
                label: $0.assignmentGroup.name,
                data: isPercent
            )
        }
        return entries
    }
}
