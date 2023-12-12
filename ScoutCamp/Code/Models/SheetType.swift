//
//  SheetType.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct SheetType: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let order: Int
}

extension SheetType {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "name": name,
            "order": order
        ]

        return map.compactMapValues { $0 }
    }
}
