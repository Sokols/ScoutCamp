//
//  FetchTeamSheetsUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

protocol FetchTeamSheetsUseCase {
    func execute(
        requestValue: FetchTeamSheetsUseCaseRequestValue
    ) async -> Result<FetchTeamSheetsUseCaseResponseValue, Error>
}

final class DefaultFetchTeamSheetsUseCase: FetchTeamSheetsUseCase {

    private let teamSheetsRepository: TeamSheetsRepository

    init(teamSheetsRepository: TeamSheetsRepository) {
        self.teamSheetsRepository = teamSheetsRepository
    }

    func execute(
        requestValue: FetchTeamSheetsUseCaseRequestValue
    ) async -> Result<FetchTeamSheetsUseCaseResponseValue, Error> {
        let result = await teamSheetsRepository.fetchTeamSheets(
            team: requestValue.team
        )

        var currentSheets: [TeamSheet] = []
        var oldSheets: [TeamSheet] = []

        if case .failure(let error) = result {
            return .failure(error)
        } else if case .success(let sheets) = result {
            currentSheets = sheets.filter { $0.sheet.period.id == requestValue.currentPeriodId }
            oldSheets = sheets.filter { $0.sheet.period.id != requestValue.currentPeriodId }
        }
        let response = FetchTeamSheetsUseCaseResponseValue(
            currentSheets: currentSheets,
            oldSheets: oldSheets
        )
        
        return .success(response)
    }
}

struct FetchTeamSheetsUseCaseResponseValue {
    let currentSheets: [TeamSheet]
    let oldSheets: [TeamSheet]
}

struct FetchTeamSheetsUseCaseRequestValue {
    let team: Team
    let currentPeriodId: String
}
