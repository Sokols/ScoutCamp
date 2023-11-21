//
//  CategoriesService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

protocol CategoriesServiceProtocol {
    func getCategories() async -> ResultArray<Category>
}

class CategoriesService: BaseService, CategoriesServiceProtocol {
    private(set) static var categories: [Category] = []

    static func getFirstCategory() -> Category? {
        return categories.sorted(by: {$0.order < $1.order}).first
    }

    static func categoryFor(id: String?) -> Category? {
        return CategoriesService.categories.first { $0.id == id }
    }

    func getCategories() async -> ResultArray<Category> {
        let result: ResultArray<Category> = await getAll(collection: .categories)
        result.0?.forEach { category in
            CategoriesService.categories.append(category)
        }
        return result
    }
}
