//
//  CategoryDTO+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension CategoryDTO {
    func toDomain() -> Category {
        return Category.init(
            id: id,
            name: name,
            imagePath: imagePath,
            order: order
        )
    }
}
