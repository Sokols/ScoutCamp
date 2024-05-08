//
//  AssignmentDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

struct AssignmentDTO: FirebaseModel {
    let id: String

    let mainAssignmentGroupId: String
    let dependentOnAssignmentId: String?
    let assignmentType: String

    let description: String
    let maxPoints: Double
    let maxScoringValue: Double?
}
