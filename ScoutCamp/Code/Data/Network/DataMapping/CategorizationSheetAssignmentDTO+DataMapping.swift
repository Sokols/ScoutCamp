//
//  CategorizationSheetAssignmentDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension CategorizationSheetAssignmentDTO {
    func toDomain() -> CategorizationSheetAssignment {
        return CategorizationSheetAssignment.init(
            id: id,
            assignmentId: assignmentId,
            categorizationSheetId: categorizationSheetId
        )
    }
}
