//
//  AppAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 22/11/2023.
//

import Foundation
import DGCharts

struct AppAssignment: Hashable {
    let assignmentId: String
    let teamAssignmentId: String?

    let mainAssignmentGroup: AssignmentGroup
    let assignmentType: AssignmentType
    let assignmentGroupShares: [AssignmentGroupShare]?

    let description: String
    let maxPoints: Double

    var isCompleted: Bool = false
    var value: Double = 0
    var maxScoringValue: Double?
}

extension AppAssignment {
    struct AssignmentGroupShare: Hashable {
        let assignmentGroup: AssignmentGroup
        let percentageShare: Double
    }
}

extension AppAssignment: Identifiable {
    var id: String {
        assignmentId + (teamAssignmentId ?? "")
    }
}

extension AppAssignment {
    var points: Double {
        if !isValid {
            return 0
        }
        switch assignmentType {
        case .numeric:
            return (value / (maxScoringValue ?? 1)) * maxPoints
        case .boolean:
            return isCompleted ? maxPoints : 0
        }
    }

    var doesContainShares: Bool {
        return !dataEntries().isEmpty
    }

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
            return "Max value is \(maxScoringValue.pointsFormatted)"
        }
        return nil
    }
}

extension AppAssignment {
    static func from(
        assignment: Assignment,
        teamAssignment: TeamCategorizationSheetAssignment?,
        groupAssignmentJunctions: [AssignmentGroupAssignmentJunction],
        groups: [AssignmentGroup]
    ) -> AppAssignment {
        let mainAssignmentGroup = groups.first { $0.id == assignment.mainAssignmentGroupId }

        var shares: [AssignmentGroupShare]?
        if !groupAssignmentJunctions.isEmpty {
            shares = groupAssignmentJunctions.compactMap { junction in
                if let group = groups.first(where: { $0.id == junction.assignmentGroupId }) {
                    return AssignmentGroupShare(
                        assignmentGroup: group,
                        percentageShare: junction.percentageShare ?? 1.0
                    )
                } else {
                    return nil
                }
            }.sorted(by: { $0.percentageShare > $1.percentageShare })
        }

        return AppAssignment(
            assignmentId: assignment.id,
            teamAssignmentId: teamAssignment?.id,
            mainAssignmentGroup: mainAssignmentGroup!,
            assignmentType: AssignmentType(rawValue: assignment.assignmentType)!,
            assignmentGroupShares: shares,
            description: assignment.description,
            maxPoints: assignment.maxPoints,
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

    func dataEntries() -> [PieChartDataEntry] {
        let entries = (assignmentGroupShares ?? []).map {
            let isPercent = points == 0
            var value = $0.percentageShare
            if !isPercent {
                value *= self.points
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
