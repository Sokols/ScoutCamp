//
//  DefaultCategorizationPeriodsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

final class DefaultCategorizationPeriodsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultCategorizationPeriodsRepository: CategorizationPeriodsRepository {
    func fetchCategorizationPeriods() async -> Result<[CategorizationPeriod], Error> {
        let result: ResultArray<CategorizationPeriodDTO> = await dataService.getAll(collection: .categorizationPeriods)
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
