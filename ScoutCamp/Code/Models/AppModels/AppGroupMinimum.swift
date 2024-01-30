//
//  AppGroupMinimum.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/01/2024.
//

import Foundation

struct AppGroupMinimum: Hashable {
    let groupMinimumId: String
    let assignmentGroupId: String

    let category: Category
    let minimumPoints: Int
}

extension AppGroupMinimum {
    static func from(groupMinimum: AssignmentGroupCategoryMinimum) -> AppGroupMinimum {
        let category = CategoriesService.categoryFor(id: groupMinimum.categoryId)!

        return AppGroupMinimum(
            groupMinimumId: groupMinimum.id,
            assignmentGroupId: groupMinimum.assignmentGroupId,
            category: category,
            minimumPoints: groupMinimum.minimumPoints
        )
    }
}
