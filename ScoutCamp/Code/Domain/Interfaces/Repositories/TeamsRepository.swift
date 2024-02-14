//
//  TeamsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

protocol TeamsRepository {
    func getUserTeams() async -> Result<[Team], Error>
}
