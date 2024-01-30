//
//  AssignmentGroupSection.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/12/2023.
//

import Foundation

struct AssignmentGroupSection {
    let group: AssignmentGroup
    let groupMinimums: [AppGroupMinimum]    // sorted from the lowest category to the highest
    var assignments: [AppAssignment]
}

extension AssignmentGroupSection {
    var totalPoints: Double {
        return assignments.map { $0.points }.reduce(0, +)
    }

    var highestPossibleCategory: Category? {
        if groupMinimums.isEmpty {
            return CategoriesService.getLastCategory()
        }
        var current: Category? = CategoriesService.getFirstCategory()
        for groupMinimum in self.groupMinimums where totalPoints >= Double(groupMinimum.minimumPoints) {
            current = groupMinimum.category
        }

        return current
    }
}
