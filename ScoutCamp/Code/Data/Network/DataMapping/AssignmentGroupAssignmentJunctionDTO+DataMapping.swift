//
//  AssignmentGroupAssignmentJunctionDTO+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 29/04/2024.
//

import Foundation

extension AssignmentGroupAssignmentJunctionDTO {
    func toDomain() -> AssignmentGroupJunction {
        return AssignmentGroupJunction(
            id: self.id,
            assignmentGroupId: self.assignmentGroupId,
            assignmentId: self.assignmentId,
            percentageShare: self.percentageShare
        )
    }
}
