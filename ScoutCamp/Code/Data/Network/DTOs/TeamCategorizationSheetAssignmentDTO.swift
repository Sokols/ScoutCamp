//
//  TeamCategorizationSheetAssignmentDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

struct TeamCategorizationSheetAssignmentDTO: FirebaseModel {
    let id: String

    let assignmentId: String
    let teamCategorizationSheetId: String

    let isCompleted: Bool?
    let value: Double?
}
