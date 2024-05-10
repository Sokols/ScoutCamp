//
//  AssignmentGroupsRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class AssignmentGroupsRepositoryMock: AssignmentGroupsRepository {

    enum AssignmentGroupsRepositoryMockError: Error {
        case failedFetching
    }

    private let isFailure: Bool
    private let groups: [AssignmentGroup]

    init(isFailure: Bool, groups: [AssignmentGroup]) {
        self.isFailure = isFailure
        self.groups = groups
    }

    func fetchAssignmentGroups(for groupdIds: [String]) async -> Result<[AssignmentGroup], Error> {
        if isFailure {
            return .failure(AssignmentGroupsRepositoryMockError.failedFetching)
        }
        let result = groups.filter { groupdIds.contains($0.id) }
        return .success(result)
    }
}

