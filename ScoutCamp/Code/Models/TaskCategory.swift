//
//  TaskCategory.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct TaskCategory: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let order: Int
    let taskCategoryTypeId: String
}

extension TaskCategory {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "name": name,
            "order": order,
            "taskCategoryTypeId": taskCategoryTypeId
        ]

        return map.compactMapValues { $0 }
    }
}
