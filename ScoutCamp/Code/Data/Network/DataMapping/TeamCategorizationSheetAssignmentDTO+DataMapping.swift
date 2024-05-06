//
//  TeamCategorizationSheetAssignmentDTO+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension TeamCategorizationSheetAssignmentDTO {
    func toDomain() -> TeamCategorizationSheetAssignment {
        return TeamCategorizationSheetAssignment(
            id: self.id,
            assignmentId: self.assignmentId,
            teamCategorizationSheetId: self.teamCategorizationSheetId,
            isCompleted: self.isCompleted,
            value: self.value
        )
    }
}
