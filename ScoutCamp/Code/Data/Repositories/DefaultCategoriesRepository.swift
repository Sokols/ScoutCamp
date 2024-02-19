//
//  DefaultCategoriesRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

final class DefaultCategoriesRepository {

    private let dataService: FirebaseDataService

    init(with dataService: FirebaseDataService) {
        self.dataService = dataService
    }
}

extension DefaultCategoriesRepository: CategoriesRepository {
    func fetchCategories() async -> Result<[Category], Error> {
        let result: ResultArray<CategoryDTO> = await dataService.getAll(collection: .categories)
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
