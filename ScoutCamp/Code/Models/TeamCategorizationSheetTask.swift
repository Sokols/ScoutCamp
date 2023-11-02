//
//  TeamCategorizationSheetTask.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct TeamCategorizationSheetTask: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categorizationSheetTaskId: String
    let teamCategorizationSheetId: String

    let isCompleted: Bool
    let isPlanned: Bool
}

extension TeamCategorizationSheetTask {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categorizationSheetTaskId": categorizationSheetTaskId,
            "teamCategorizationSheetId": teamCategorizationSheetId,
            "isCompleted": isCompleted,
            "isPlanned": isPlanned
        ]

        return map.compactMapValues { $0 }
    }
}
