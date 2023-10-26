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

    static func categoryFor(id: String?) -> String {
        return CategoriesService.categories.first { $0.id == id }?.name ?? "-"
    }

    func getCategories() async -> ResultArray<Category> {
        let result: ResultArray<Category> = await getAll(collection: .categories)
        result.0?.forEach { category in
            CategoriesService.categories.append(category)
        }
        return result
    }
}
