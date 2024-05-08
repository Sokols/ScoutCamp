//
//  CategorizationPeriodDTO+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension CategorizationPeriodDTO {
    func toDomain() -> CategorizationPeriod? {
        return CategorizationPeriod.init(
            id: id,
            name: name
        )
    }
}
