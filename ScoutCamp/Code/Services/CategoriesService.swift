//
//  CategoriesService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

protocol CategoriesServiceProtocol {
    func getCategories() async -> ResultArray<Category>
    func setupCategoryUrls(_ urls: [String: URL])
}

final class CategoriesService: BaseService, CategoriesServiceProtocol {
    private(set) static var categories: [Category] = []
    private static var categoryUrls: [String: URL] = [:]

    static func getFirstCategory() -> Category? {
        return categories.sorted(by: {$0.order < $1.order}).first
    }

    static func categoryFor(id: String?) -> Category? {
        return CategoriesService.categories.first { $0.id == id }
    }

    static func urlFor(id: String?) -> URL? {
        return CategoriesService.categoryUrls[id ?? ""]
    }

    func setupCategoryUrls(_ urls: [String: URL]) {
        CategoriesService.categoryUrls = urls
    }

    func getCategories() async -> ResultArray<Category> {
        let result: ResultArray<Category> = await getAll(collection: .categories)
        result.0?.forEach { category in
            CategoriesService.categories.append(category)
        }
        return result
    }
}
