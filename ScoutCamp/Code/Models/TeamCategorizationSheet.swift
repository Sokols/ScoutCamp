//
//  TeamCategorizationSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct TeamCategorizationSheet: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categorizationSheetId: String
    let teamId: String

    let points: Int
    let isDraft: Bool

    let createdAt: Date
    let upatedAt: Date
}

extension TeamCategorizationSheet {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categorizationSheetId": categorizationSheetId,
            "teamId": teamId,
            "points": points,
            "isDraft": isDraft,
            "createdAt": createdAt,
            "upatedAt": upatedAt
        ]

        return map.compactMapValues { $0 }
    }
}
