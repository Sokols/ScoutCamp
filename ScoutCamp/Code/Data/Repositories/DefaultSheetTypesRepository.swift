//
//  DefaultSheetTypesRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

final class DefaultSheetTypesRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultSheetTypesRepository: SheetTypesRepository {
    func fetchSheetTypes() async -> Result<[SheetType], Error> {
        let result: ResultArray<SheetTypeDTO> = await dataService.getAll(collection: .sheetTypes)
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
