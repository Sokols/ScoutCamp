//
//  CategoriesRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

protocol CategoriesRepository {
    func fetchCategories() async -> Result<[Category], Error>
    func fetchCategoryUrls(for imagePaths: [String]) async -> Result<[String:URL], Error>
}
