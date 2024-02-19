//
//  AssignmentGroupCategoryMinimum+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension AssignmentGroupCategoryMinimumDTO {
    func toDomain(category: Category) -> AssignmentGroupCategoryMinimum {
        return AssignmentGroupCategoryMinimum(
            groupMinimumId: self.id,
            assignmentGroupId: self.assignmentGroupId,
            category: category,
            minimumPoints: self.minimumPoints
        )
    }
}
