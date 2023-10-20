//
//  CategorizationSheetTask.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct CategorizationSheetTask: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categorizationSheedId: String
    let taskId: String
}

extension CategorizationSheetTask {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categorizationSheedId": categorizationSheedId,
            "taskId": taskId
        ]

        return map.compactMapValues { $0 }
    }
}
