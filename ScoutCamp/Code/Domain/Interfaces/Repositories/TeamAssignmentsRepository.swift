//
//  TeamAssignmentsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/04/2024.
//

import Foundation

protocol TeamAssignmentsRepository {
    func saveTeamAssignments(_ assignments: [AppAssignment], teamSheetId: String) async -> Error?
    func fetchTeamAssignments(teamSheetId: String) async -> Result<[TeamCategorizationSheetAssignment], Error>
}
