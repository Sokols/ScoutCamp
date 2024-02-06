//
//  AssignmentGroupCategoryMinimum+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension AssignmentGroupCategoryMinimumDTO {
    func toDomain() -> AssignmentGroupCategoryMinimum? {
        guard let category = CategoriesService.categoryFor(id: self.categoryId) else { return nil }

        return AssignmentGroupCategoryMinimum(
            groupMinimumId: self.id,
            assignmentGroupId: self.assignmentGroupId,
            category: category.toDomain(),
            minimumPoints: self.minimumPoints
        )
    }
}
