//
//  AssignmentGroupJunctionsRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class AssignmentGroupJunctionsRepositoryMock: AssignmentGroupJunctionsRepository {

    enum AssignmentGroupJunctionsRepositoryMockError: Error {
        case failedFetching
    }

    private let isFailure: Bool
    private let junctions: [AssignmentGroupJunction]

    init(isFailure: Bool, junctions: [AssignmentGroupJunction]) {
        self.isFailure = isFailure
        self.junctions = junctions
    }

    func fetchAssignmentJunctions(for assignmentIds: [String]) async -> Result<[AssignmentGroupJunction], Error> {
        if isFailure {
            return .failure(AssignmentGroupJunctionsRepositoryMockError.failedFetching)
        }
        let result = junctions.filter { assignmentIds.contains($0.assignmentId) }
        return .success(result)
    }
}
