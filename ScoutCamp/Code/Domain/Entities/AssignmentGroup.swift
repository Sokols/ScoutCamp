//
//  AssignmentGroup.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

struct AssignmentGroup {
    let id: String
    let name: String
    let order: Int
}

extension AssignmentGroup: Hashable {}
