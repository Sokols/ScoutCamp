//
//  Category.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct Category: FirebaseModel, Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var imagePath: String
}

extension Category {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "name": name,
            "imagePath": imagePath
        ]

        return map.compactMapValues { $0 }
    }
}
