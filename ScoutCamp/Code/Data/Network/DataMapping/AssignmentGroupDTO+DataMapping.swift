//
//  AssignmentGroup+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension AssignmentGroupDTO {
    func toDomain() -> AssignmentGroup {
        return AssignmentGroup.init(
            id: id,
            name: name,
            order: order
        )
    }
}
