//
//  TeamSheetsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

protocol TeamSheetsRepository {
    func fetchTeamSheets(team: Team) async -> Result<[TeamSheet], Error>
}
