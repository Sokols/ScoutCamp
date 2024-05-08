//
//  AssignmentGroupSection.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/12/2023.
//

import Foundation

struct AssignmentGroupSection {
    let group: AssignmentGroup
    let groupMinimums: [AssignmentGroupCategoryMinimum]    // sorted from the lowest category to the highest
    var assignments: [AppAssignment]
    var partialAssignments: [AppAssignment]
}

extension AssignmentGroupSection {
    var totalPoints: Double {
        let sum = assignments.map { $0.getPoints() }.reduce(0, +)
        + partialAssignments.map { $0.getPoints(groupId: group.id) }.reduce(0, +)
        return sum.isNaN ? 0 : sum
    }

    func getHighestPossibleCategory(from categories: [Category]) -> Category? {
        if groupMinimums.isEmpty {
            return categories.getLastCategory()
        }
        var current: Category? = categories.getFirstCategory()
        for groupMinimum in self.groupMinimums where totalPoints >= Double(groupMinimum.minimumPoints) {
            current = groupMinimum.category
        }

        return current
    }
}
