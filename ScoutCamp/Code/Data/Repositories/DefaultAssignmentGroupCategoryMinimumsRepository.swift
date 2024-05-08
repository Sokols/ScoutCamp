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
    private let fetchCategoriesUseCase: FetchCategoriesUseCase

    init(
        with dataService: FirebaseDataService,
        fetchCategoriesUseCase: FetchCategoriesUseCase
    ) {
        self.dataService = dataService
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
}

extension DefaultAssignmentGroupCategoryMinimumsRepository: AssignmentGroupCategoryMinimumsRepository {
    func fetchGroupMinimums(for groupIds: [String]) async -> Result<[AssignmentGroupCategoryMinimum], Error> {
        // Fetch categories
        let categoriesResult = await fetchCategoriesUseCase.execute()

        var categories: [Category] = []
        do {
            categories = try categoriesResult.get().categories
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
