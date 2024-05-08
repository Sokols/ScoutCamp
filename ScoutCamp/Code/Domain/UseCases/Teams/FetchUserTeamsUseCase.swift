//
//  FetchUserTeamsUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/02/2024.
//

import Foundation

protocol FetchUserTeamsUseCase {
    func execute() async -> Result<[Team], Error>
}

final class DefaultFetchUserTeamsUseCase: FetchUserTeamsUseCase {

    private let teamsRepository: TeamsRepository

    init(teamsRepository: TeamsRepository) {
        self.teamsRepository = teamsRepository
    }

    func execute() async -> Result<[Team], Error> {
        return await teamsRepository.getUserTeams()
    }
}
