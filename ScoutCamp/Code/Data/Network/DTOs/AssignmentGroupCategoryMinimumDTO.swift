//
//  AssignmentGroupCategoryMinimumDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/01/2024.
//

import Foundation

struct AssignmentGroupCategoryMinimumDTO: FirebaseModel {
    let id: String
    let assignmentGroupId: String
    let categoryId: String
    let minimumPoints: Int
}
