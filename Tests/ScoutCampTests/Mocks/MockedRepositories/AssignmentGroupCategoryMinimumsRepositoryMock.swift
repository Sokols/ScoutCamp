//
//  AssignmentGroupCategoryMinimumsRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class AssignmentGroupCategoryMinimumsRepositoryMock: AssignmentGroupCategoryMinimumsRepository {

    enum AssignmentGroupCategoryMinimumsRepositoryMockError: Error {
        case failedFetching
    }

    private let isFailure: Bool
    private let minimums: [AssignmentGroupCategoryMinimum]

    init(isFailure: Bool, minimums: [AssignmentGroupCategoryMinimum]) {
        self.isFailure = isFailure
        self.minimums = minimums
    }

    func fetchGroupMinimums(for groupIds: [String]) async -> Result<[AssignmentGroupCategoryMinimum], Error> {
        if isFailure {
            return .failure(AssignmentGroupCategoryMinimumsRepositoryMockError.failedFetching)
        }

        let result = minimums.filter { groupIds.contains($0.assignmentGroupId) }
        return .success(result)
    }
}

