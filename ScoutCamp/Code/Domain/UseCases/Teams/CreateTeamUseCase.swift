//
//  CreateTeamUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/05/2024.
//

import Foundation

protocol CreateTeamUseCase {
    func execute(requestValue: CreateTeamUseCaseRequestValue) async -> Result<Team, Error>
}

final class DefaultCreateTeamUseCase: CreateTeamUseCase {

    private let teamsRepository: TeamsRepository

    init(teamsRepository: TeamsRepository) {
        self.teamsRepository = teamsRepository
    }

    func execute(requestValue: CreateTeamUseCaseRequestValue) async -> Result<Team, Error> {
        return await teamsRepository.createTeam(
            regimentId: requestValue.regimentId,
            troopId: requestValue.troopId,
            name: requestValue.name
        )
    }
}

struct CreateTeamUseCaseRequestValue {
    let regimentId: String
    let troopId: String
    let name: String
}
