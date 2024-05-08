//
//  TeamSheetDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct TeamSheetDTO: FirebaseModel {
    let id: String

    let categorizationSheetId: String
    let teamId: String
    let categoryId: String

    let points: Double
    let isDraft: Bool

    let createdAt: Date
    let updatedAt: Date
}
