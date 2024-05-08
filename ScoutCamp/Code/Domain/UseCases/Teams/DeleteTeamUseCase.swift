//
//  DeleteTeamUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 08/05/2024.
//

import Foundation

protocol DeleteTeamUseCase {
    func execute(requestValue: DeleteTeamUseCaseRequestValue) async -> Error?
}

final class DefaultDeleteTeamUseCase: DeleteTeamUseCase {

    private let teamsRepository: TeamsRepository

    init(teamsRepository: TeamsRepository) {
        self.teamsRepository = teamsRepository
    }

    func execute(requestValue: DeleteTeamUseCaseRequestValue) async -> Error? {
        return await teamsRepository.deleteTeam(teamId: requestValue.teamId)
    }
}

struct DeleteTeamUseCaseRequestValue {
    let teamId: String
}
