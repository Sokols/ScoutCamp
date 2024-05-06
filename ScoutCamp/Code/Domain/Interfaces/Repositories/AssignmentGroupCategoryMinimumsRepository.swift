//
//  AssignmentGroupCategoryMinimumsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

protocol AssignmentGroupCategoryMinimumsRepository {
    func fetchGroupMinimums(for groupIds: [String]) async -> Result<[AssignmentGroupCategoryMinimum], Error>
}
