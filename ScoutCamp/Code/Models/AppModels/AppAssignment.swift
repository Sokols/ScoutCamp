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

    let category: Category?
    let mainAssignmentGroup: AssignmentGroup
    let assignmentType: AssignmentType
    let assignmentGroupShares: [AssignmentGroupShare]?

    let description: String
    let maxPoints: Double
    let minimums: [CategoryMinimum]?

    var isCompleted: Bool = false
    var value: Double = 0
    var maxScoringValue: Double?
}

extension AppAssignment {
    struct CategoryMinimum: Hashable, Identifiable {
        let id = UUID()
        let category: Category
        let minimum: Double
    }
}

extension AppAssignment {
    struct AssignmentGroupShare: Hashable {
        let assignmentGroup: AssignmentGroup
        let percentageShare: Double
    }
}

extension AppAssignment {
    var nextCategoryMinimumBasedOnPoints: CategoryMinimum? {
        switch assignmentType {
        case .boolean:
            return nil
        case .numeric:
            if let minimums {
                var current: CategoryMinimum?
                for minimum in minimums.reversed() where value < minimum.minimum {
                    current = minimum
                }
                return current
            }
            return nil
        }
    }

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
        groupAssignmentJunctions: [AssignmentGroupAssignmentJunction]
    ) -> AppAssignment {
        let category = CategoriesService.categoryFor(id: assignment.categoryId)
        let mainAssignmentGroup = AssignmentGroupsService.getAssignmentGroupFor(id: assignment.mainAssignmentGroupId)
        var minimums: [CategoryMinimum]?
        if let dataMinimums = assignment.minimums {
            minimums = dataMinimums.compactMap {
                if let category = CategoriesService.categoryFor(id: $0.key) {
                    return CategoryMinimum(category: category, minimum: $0.value)
                }
                return nil
            }.sorted(by: {$0.category.order < $1.category.order })
        }
        var shares: [AssignmentGroupShare]?
        if !groupAssignmentJunctions.isEmpty {
            shares = groupAssignmentJunctions.map {
                let group = AssignmentGroupsService.getAssignmentGroupFor(id: $0.assignmentGroupId)!
                return AssignmentGroupShare(assignmentGroup: group, percentageShare: $0.percentageShare ?? 1.0)
            }.sorted(by: { $0.percentageShare > $1.percentageShare })
        }

        return AppAssignment(
            assignmentId: assignment.id,
            teamAssignmentId: teamAssignment?.id,
            category: category,
            mainAssignmentGroup: mainAssignmentGroup!,
            assignmentType: AssignmentType(rawValue: assignment.assignmentType)!,
            assignmentGroupShares: shares,
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

    func dataEntries() -> [PieChartDataEntry] {
        let entries = (assignmentGroupShares ?? []).map {
            let value = $0.percentageShare * self.points
            return PieChartDataEntry(
                value: value,
                label: $0.assignmentGroup.name
            )
        }
        return entries
    }
}
