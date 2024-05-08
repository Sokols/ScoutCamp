//
//  Assignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 22/11/2023.
//

import Foundation
import DGCharts

class AppAssignment {
    let assignmentId: String
    let teamAssignmentId: String?

    let mainAssignmentGroup: AssignmentGroup
    let assignmentType: AssignmentType
    let assignmentGroupShares: [AssignmentGroupShare]?

    let description: String
    let maxPoints: Double

    var isCompleted: Bool
    var value: Double
    var maxScoringValue: Double?

    var dependentOnAssignment: AppAssignment?

    init(
        assignmentId: String,
        teamAssignmentId: String?,
        mainAssignmentGroup: AssignmentGroup,
        assignmentType: AssignmentType,
        assignmentGroupShares: [AssignmentGroupShare]?,
        description: String,
        maxPoints: Double,
        isCompleted: Bool = false,
        value: Double = 0,
        maxScoringValue: Double? = nil,
        dependentOnAssignment: AppAssignment? = nil
    ) {
        self.assignmentId = assignmentId
        self.teamAssignmentId = teamAssignmentId
        self.mainAssignmentGroup = mainAssignmentGroup
        self.assignmentType = assignmentType
        self.assignmentGroupShares = assignmentGroupShares
        self.description = description
        self.maxPoints = maxPoints
        self.isCompleted = isCompleted
        self.value = value
        self.maxScoringValue = maxScoringValue
        self.dependentOnAssignment = dependentOnAssignment
    }
}

extension AppAssignment: Identifiable, Hashable {
    var id: String {
        assignmentId + "_" + (teamAssignmentId ?? "")
    }

    static func == (lhs: AppAssignment, rhs: AppAssignment) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

extension AppAssignment {
    struct AssignmentGroupShare: Hashable {
        let assignmentGroup: AssignmentGroup
        let percentageShare: Double
    }
}

extension AppAssignment {
    enum AssignmentType: String {
        case boolean, numeric
    }
}

extension AppAssignment {

    private var calculatedPoints: Double {
        var calculatedValue: Double = 0
        switch assignmentType {
        case .numeric:
            if let maxScoringValue {
                calculatedValue = (value / maxScoringValue) * maxPoints
            } else if let dependentOnAssignment {
                calculatedValue = (value / dependentOnAssignment.value) * maxPoints
            }
            calculatedValue = calculatedValue > maxPoints ? maxPoints : calculatedValue
        case .boolean:
            calculatedValue = isCompleted ? maxPoints : 0
        }

        return calculatedValue.isNaN ? 0 : calculatedValue
    }

    var doesContainShares: Bool {
        return !dataEntries().isEmpty
    }

    var isValueValid: Bool {
        if let maxScoringValue {
            return value <= maxScoringValue
        }
        if let dependentOnAssignment {
            return value <= dependentOnAssignment.value
        }
        return true
    }

    var errorPrompt: String? {
        if !isValueValid {
            if let maxScoringValue {
                return "Max value is \(maxScoringValue.pointsFormatted)"
            } else if let dependentOnAssignment {
                return "This assignment depends on other assignment.\nMax value is \(Int(dependentOnAssignment.value))"
            }
        }
        return nil
    }

    func getPoints(groupId: String? = nil) -> Double {
        let groupId = groupId ?? mainAssignmentGroup.id
        if let assignmentGroupShares,
           let groupShare = assignmentGroupShares.first(where: { $0.assignmentGroup.id == groupId }) {
            return calculatedPoints * groupShare.percentageShare
        }
        return calculatedPoints
    }

    func getMaxPoints(groupId: String? = nil) -> Double {
        let groupId = groupId ?? mainAssignmentGroup.id
        if let assignmentGroupShares,
           let groupShare = assignmentGroupShares.first(where: { $0.assignmentGroup.id == groupId }) {
            return maxPoints * groupShare.percentageShare
        }
        return maxPoints
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
