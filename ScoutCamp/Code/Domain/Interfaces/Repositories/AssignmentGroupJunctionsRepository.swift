//
//  AssignmentGroupJunctionsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 29/04/2024.
//

import Foundation

protocol AssignmentGroupJunctionsRepository {
    func fetchAssignmentJunctions(for assignmentIds: [String]) async -> Result<[AssignmentGroupJunction], Error>
}
