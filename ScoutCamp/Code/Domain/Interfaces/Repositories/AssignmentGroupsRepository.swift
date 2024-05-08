//
//  AssignmentGroupsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

protocol AssignmentGroupsRepository {
    func fetchAssignmentGroups(for groupdIds: [String]) async -> Result<[AssignmentGroup], Error>
}
