//
//  TeamsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

protocol TeamsRepository {
    func getUserTeams() async -> Result<[Team], Error>
    func createTeam(regimentId: String, troopId: String, name: String) async -> Result<Team, Error>
    func getRegiments() async -> Result<[Team], Error>
    func getTroopsForRegiment(regimentId: String) async -> Result<[Team], Error>
    func getTeamsForTroop(troopId: String) async -> Result<[Team], Error>
    func updateTeam(_ team: Team, regimentId: String?, troopId: String?, name: String?) async -> Error?
    func deleteTeam(teamId: String) async -> Error?
}
