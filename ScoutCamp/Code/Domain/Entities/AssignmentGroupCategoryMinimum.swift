//
//  AssignmentGroupCategoryMinimum.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/01/2024.
//

import Foundation

struct AssignmentGroupCategoryMinimum: Hashable {
    let groupMinimumId: String
    let assignmentGroupId: String

    let category: Category
    let minimumPoints: Int
}
