//
//  AssignmentGroupAssignmentJunctionDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 05/11/2023.
//

import Foundation

struct AssignmentGroupAssignmentJunctionDTO: FirebaseModel {
    let id: String

    let assignmentGroupId: String
    let assignmentId: String

    let percentageShare: Double?
}
