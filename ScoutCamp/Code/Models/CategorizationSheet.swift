//
//  CategorizationSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct CategorizationSheet: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String

    let periodId: String
    let sheetTypeId: String
}

extension CategorizationSheet {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "periodId": periodId,
            "sheetTypeId": sheetTypeId
        ]

        return map.compactMapValues { $0 }
    }
}
