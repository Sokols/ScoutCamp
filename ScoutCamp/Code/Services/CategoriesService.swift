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
    func getCategories() async -> ResultArray<Category> {
        await getAll(collection: .categories)
    }
}
