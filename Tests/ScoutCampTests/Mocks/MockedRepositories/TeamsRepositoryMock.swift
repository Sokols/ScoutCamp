//
//  TeamsRepositoryMock.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 09/05/2024.
//

import Foundation
@testable import ScoutCamp

final class TeamsRepositoryMock: TeamsRepository {

    enum TeamsRepositoryMockError: Error {
        case failedFetching
        case failedDeletion
        case failedCreation
        case failedUpdate
    }

    private let isFailure: Bool
    private let userId = "USER_ID"

    private let troops = [TestData.troop]
    private let regiments = [TestData.regiment]
    private var teams: [Team] = []

    init(isFailure: Bool) {
        self.isFailure = isFailure
    }

    func getUserTeams() async -> Result<[Team], Error> {
        if isFailure {
            return .failure(TeamsRepositoryMockError.failedFetching)
        }
        let result = teams.filter { $0.userId == userId }
        return .success(result)
    }

    func createTeam(regimentId: String, troopId: String, name: String) async -> Result<Team, Error> {
        if isFailure {
            return .failure(TeamsRepositoryMockError.failedCreation)
        }
        let team = Team(
            id: UUID().uuidString,
            userId: userId,
            troopId: troopId,
            regimentId: regimentId,
            name: name
        )
        teams.append(team)
        return .success(team)
    }

    func getRegiments() async -> Result<[Team], Error> {
        if isFailure {
            return .failure(TeamsRepositoryMockError.failedFetching)
        }
        return .success(regiments)
    }

    func getTroopsForRegiment(regimentId: String) async -> Result<[Team], Error> {
        if isFailure {
            return .failure(TeamsRepositoryMockError.failedFetching)
        }
        let result = troops.filter { $0.regimentId == regimentId }
        return .success(result)
    }

    func getTeamsForTroop(troopId: String) async -> Result<[Team], Error> {
        if isFailure {
            return .failure(TeamsRepositoryMockError.failedFetching)
        }
        let result = teams.filter { $0.troopId == troopId }
        return .success(result)
    }

    func updateTeam(_ team: Team, regimentId: String?, troopId: String?, name: String?) async -> Error? {
        if isFailure {
            return TeamsRepositoryMockError.failedUpdate
        }
        let updatedTeam = Team(
            id: team.id,
            userId: team.userId,
            troopId: troopId ?? team.troopId,
            regimentId: regimentId ?? team.regimentId,
            name: name ?? team.name
        )
        if let index = teams.firstIndex(where: { $0.id == team.id }) {
            teams[index] = updatedTeam
        }
        return nil
    }

    func deleteTeam(teamId: String) async -> Error? {
        if isFailure {
            return TeamsRepositoryMockError.failedDeletion
        }
        if let index = teams.firstIndex(where: { $0.id == teamId }) {
            teams.remove(at: index)
            return nil
        } else {
            return TeamsRepositoryMockError.failedDeletion
        }
    }
}
