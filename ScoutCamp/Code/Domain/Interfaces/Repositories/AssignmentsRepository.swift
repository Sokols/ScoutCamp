//
//  AssignmentsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

protocol AssignmentsRepository {
    func fetchAssignments(for ids: [String]) async -> Result<[Assignment], Error>
}
