//
//  AssignmentGroupJunction.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 29/04/2024.
//

import Foundation

struct AssignmentGroupJunction: FirebaseModel {
    let id: String

    let assignmentGroupId: String
    let assignmentId: String

    let percentageShare: Double?
}
