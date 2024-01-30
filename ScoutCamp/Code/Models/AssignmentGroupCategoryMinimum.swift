//
//  AssignmentGroupCategoryMinimum.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/01/2024.
//

import Foundation

struct AssignmentGroupCategoryMinimum: FirebaseModel, Hashable {
    let id: String
    let assignmentGroupId: String
    let categoryId: String
    let minimumPoints: Int
}
