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
        do {
            let result = await categoriesRepository.fetchCategories()
            var categories = try result.get()

            let categoryImagePaths = categories.map { $0.imagePath }
            let urlsResult = await categoriesRepository.fetchCategoryUrls(for: categoryImagePaths)
            let urls = try urlsResult.get()

            for (index, category) in categories.enumerated() {
                categories[index].url = urls.first { $0.key == category.imagePath }?.value
            }

            let response = FetchCategoriesUseCaseResponseValue(categories: categories)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}

struct FetchCategoriesUseCaseResponseValue {
    let categories: [Category]
}
