//
//  DefaultCategoriesRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

final class DefaultCategoriesRepository {

    private let dataService: FirebaseDataService
    private let storageManager: StorageManager

    init(
        with dataService: FirebaseDataService,
        storageManager: StorageManager
    ) {
        self.dataService = dataService
        self.storageManager = storageManager
    }
}

extension DefaultCategoriesRepository: CategoriesRepository {
    func fetchCategoryUrls(for imagePaths: [String]) async -> Result<[String:URL], Error> {
        do {
            let urls = try await storageManager.getImageUrls(from: imagePaths)
            return .success(urls)
        } catch {
            return .failure(error)
        }
    }

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
