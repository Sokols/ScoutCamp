//
//  TeamCategorizationSheetAssignment.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct TeamCategorizationSheetAssignment: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let assignmentId: String
    let teamCategorizationSheetId: String

    var isCompleted: Bool?
    var value: Decimal?
}
