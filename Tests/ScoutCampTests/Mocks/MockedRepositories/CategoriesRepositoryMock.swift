//
//  CategoriesRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 13/05/2024.
//

import Foundation
@testable import ScoutCamp

final class CategoriesRepositoryMock: CategoriesRepository {

    enum CategoriesRepositoryMockError: Error {
        case failedCategoriesFetching
        case failedCategoryUrlsFetching
    }

    private let isFailure: Bool
    private let categories = [TestData.firstCategory, TestData.secondCategory]

    init(isFailure: Bool) {
        self.isFailure = isFailure
    }

    func fetchCategories() async -> Result<[ScoutCamp.Category], Error> {
        if isFailure {
            return .failure(CategoriesRepositoryMockError.failedCategoriesFetching)
        }
        return .success(categories)
    }

    func fetchCategoryUrls(for imagePaths: [String]) async -> Result<[String : URL], Error> {
        if isFailure {
            return .failure(CategoriesRepositoryMockError.failedCategoryUrlsFetching)
        }
        var result: [String: URL] = [:]
        for imagePath in imagePaths {
            if let url = URL(string: imagePath) {
                result.updateValue(url, forKey: imagePath)
            }
        }
        return .success(result)
    }
}

