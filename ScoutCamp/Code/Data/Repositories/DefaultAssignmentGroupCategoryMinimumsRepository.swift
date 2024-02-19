//
//  DefaultGroupMinimumsRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation
import FirebaseFirestore

final class DefaultAssignmentGroupCategoryMinimumsRepository {

    private let dataService: FirebaseDataService
    private let categoriesRepository: CategoriesRepository

    init(
        with dataService: FirebaseDataService,
        categoriesRepository: CategoriesRepository
    ) {
        self.dataService = dataService
        self.categoriesRepository = categoriesRepository
    }
}

extension DefaultAssignmentGroupCategoryMinimumsRepository: AssignmentGroupCategoryMinimumsRepository {
    func fetchGroupMinimums(groupIds: [String]) async -> Result<[AssignmentGroupCategoryMinimum], Error> {
        // Fetch categories
        let categoriesResult = await categoriesRepository.fetchCategories()
        if case .failure(let error) = categoriesResult {
            return .failure(error)
        }

        var categories: [Category] = []
        do {
            categories = try categoriesResult.get()
        } catch {
            return .failure(error)
        }

        if groupIds.isEmpty {
            return .success([])
        }

        // Fetch minimums
        let query = Firestore.firestore()
            .collection(FirebaseCollection.assignmentGroupCategoryMinimums.rawValue)
            .whereField("assignmentGroupId", in: groupIds)

        let result: ResultArray<AssignmentGroupCategoryMinimumDTO> = await dataService.fetch(query: query)

        // Parse data
        if let data = result.0 {
            let mappedData: [AssignmentGroupCategoryMinimum] = data.compactMap { minimum in
                guard let category = categories.first(where: {$0.id == minimum.categoryId}) else {
                    return nil
                }
                return minimum.toDomain(category: category)
            }
            return .success(mappedData)
        }
        if let error = result.1 {
            return .failure(error)
        }
        return .failure(AppError.generalError)
    }
}
