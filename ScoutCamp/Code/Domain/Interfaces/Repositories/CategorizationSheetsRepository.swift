//
//  CategorizationSheetsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

protocol CategorizationSheetsRepository {
    func fetchCategorizationSheets() async -> Result<[CategorizationSheet], Error>
    func fetchAssignments(for sheetId: String) async -> Result<[CategorizationSheetAssignment], Error>
}
