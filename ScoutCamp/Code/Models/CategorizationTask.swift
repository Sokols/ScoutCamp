//
//  CategorizationTask.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct CategorizationTask: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let categoryId: String
    let taskCategoryId: String

    let name: String
    let isMandatory: Bool
}

extension CategorizationTask {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "categoryId": categoryId,
            "taskCategoryId": taskCategoryId,
            "name": name,
            "isMandatory": isMandatory
        ]

        return map.compactMapValues { $0 }
    }
}
