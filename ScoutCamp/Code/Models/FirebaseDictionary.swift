//
//  FirebaseDictionary.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift

protocol FirebaseDictionary: FirebaseModel, Identifiable, Equatable, Hashable {
    var id: String { get set }
    var name: String { get set }
}

extension FirebaseDictionary {
    func toCreateMap() -> [String: Any] {
        let map: [String: Any?] = [
            "id": id,
            "name": name
        ]

        return map.compactMapValues { $0 }
    }
}
