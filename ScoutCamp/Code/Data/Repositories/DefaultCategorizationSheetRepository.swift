//
//  DefaultCategorizationSheetsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

final class DefaultCategorizationSheetsRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultCategorizationSheetsRepository: CategorizationSheetsRepository {
    func fetchCategorizationSheets() async -> Result<[CategorizationSheet], Error> {
        let result: ResultArray<CategorizationSheetDTO> = await dataService.getAll(collection: .categorizationSheets)
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
