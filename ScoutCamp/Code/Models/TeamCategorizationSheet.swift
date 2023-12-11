//
//  TeamCategorizationSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct TeamCategorizationSheet: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categorizationSheetId: String
    let teamId: String
    let categoryId: String

    let points: Double
    let isDraft: Bool

    let createdAt: Date
    let updatedAt: Date
}

extension TeamCategorizationSheet {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categorizationSheetId": categorizationSheetId,
            "teamId": teamId,
            "categoryId": categoryId,
            "points": points,
            "isDraft": isDraft,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]

        return map.compactMapValues { $0 }
    }
}
