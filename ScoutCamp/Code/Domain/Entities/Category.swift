//
//  Category.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct Category: Hashable {
    let id: String
    let name: String
    let imagePath: String
    let order: Int

    var url: URL?
}

extension [Category] {
    func getFirstCategory() -> Category? {
        return self.sorted(by: {$0.order < $1.order}).first
    }

    func getLastCategory() -> Category? {
        return self.sorted(by: {$0.order > $1.order}).first
    }

    func categoryFor(id: String?) -> Category? {
        return self.first { $0.id == id }
    }
}
