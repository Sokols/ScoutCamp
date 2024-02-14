//
//  DefaultTeamsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

final class DefaultTeamsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultTeamsRepository: TeamsRepository {
    func getUserTeams() async -> Result<[Team], Error> {
        let result: ResultArray<TeamDTO> = await dataService.getUserItems(
            collection: .teams,
            orderBy: "name",
            limit: nil,
            offset: nil
        )
        if let data = result.0 {
            let mappedData = data.compactMap { $0.toDomain() }
            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
}
