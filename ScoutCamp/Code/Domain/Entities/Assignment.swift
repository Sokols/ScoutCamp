//
//  Assignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 22/11/2023.
//

import Foundation

class Assignment {
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

    var dependentOnAssignment: Assignment?

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
        dependentOnAssignment: Assignment? = nil
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

extension Assignment: Identifiable, Hashable {
    var id: String {
        assignmentId + (teamAssignmentId ?? "")
    }

    static func == (lhs: Assignment, rhs: Assignment) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

extension Assignment {
    struct AssignmentGroupShare: Hashable {
        let assignmentGroup: AssignmentGroup
        let percentageShare: Double
    }
}

extension Assignment {
    enum AssignmentType: String {
        case boolean, numeric
    }
}

extension Assignment {

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
