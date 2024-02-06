//
//  Category.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct Category {
    let id: String
    let name: String
    let imagePath: String
    let order: Int
}

extension Category: Hashable {}

extension Category {
    var url: URL? {
        CategoriesService.urlFor(id: id)
    }
}
