//
//  Assignment+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation
import DGCharts

extension AssignmentDTO {
    func toDomain() -> Assignment {
        return Assignment(
            id: self.id,
            mainAssignmentGroupId: self.id,
            dependentOnAssignmentId: self.dependentOnAssignmentId,
            assignmentType: self.assignmentType,
            description: self.description,
            maxPoints: self.maxPoints,
            maxScoringValue: self.maxScoringValue
        )
    }
}
