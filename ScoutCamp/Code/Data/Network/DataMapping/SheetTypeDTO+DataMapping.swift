//
//  SheetTypeDTO+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension SheetTypeDTO {
    func toDomain() -> SheetType {
        return SheetType.init(
            id: id,
            name: name,
            order: order
        )
    }
}
