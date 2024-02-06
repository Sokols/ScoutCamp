//
//  TeamCategorizationSheetAssignmentDTO+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension TeamCategorizationSheetAssignmentDTO {
    func toDomain() -> TeamCategorizationSheetAssignment {
        return TeamCategorizationSheetAssignment.init(
            id: id,
            assignmentId: assignmentId,
            teamCategorizationSheetId: teamCategorizationSheetId
        )
    }
}
