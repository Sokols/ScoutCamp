//
//  SheetType.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct SheetType: FirebaseModel, Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var order: Int
    var isScoredSheet: Bool
}

extension SheetType {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "name": name,
            "order": order,
            "isScoredSheet": isScoredSheet
        ]

        return map.compactMapValues { $0 }
    }
}
