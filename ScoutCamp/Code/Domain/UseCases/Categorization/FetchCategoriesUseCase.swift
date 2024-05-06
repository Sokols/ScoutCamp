//
//  FetchCategoriesUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 29/04/2024.
//

import Foundation

protocol FetchCategoriesUseCase {
    func execute() async -> Result<FetchCategoriesUseCaseResponseValue, Error>
}

final class DefaultFetchCategoriesUseCase: FetchCategoriesUseCase {

    private let categoriesRepository: CategoriesRepository

    init(categoriesRepository: CategoriesRepository) {
        self.categoriesRepository = categoriesRepository
    }

    func execute() async -> Result<FetchCategoriesUseCaseResponseValue, Error> {
        let result = await categoriesRepository.fetchCategories()

        switch result {
        case .success(let success):
            return .success(FetchCategoriesUseCaseResponseValue(categories: success))
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

struct FetchCategoriesUseCaseResponseValue {
    let categories: [Category]
}
