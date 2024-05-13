//
//  CategorizationSheetAssignmentsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation

protocol CategorizationSheetAssignmentsRepository {
    func fetchAssignments(for sheetId: String) async -> Result<[CategorizationSheetAssignment], Error>
}
