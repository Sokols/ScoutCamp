//
//  AssignmentGroupsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

protocol AssignmentGroupsServiceProtocol {
    func getAssignmentGroups() async -> ResultArray<AssignmentGroup>
}

final class AssignmentGroupsService: BaseService, AssignmentGroupsServiceProtocol {
    private(set) static var assignmentGroups: [AssignmentGroup] = []

    static func getAssignmentGroupFor(id: String?) -> AssignmentGroup? {
        return AssignmentGroupsService.assignmentGroups.first { $0.id == id }
    }

    func getAssignmentGroups() async -> ResultArray<AssignmentGroup> {
        let result: ResultArray<AssignmentGroup> = await getAll(collection: .assignmentGroups)
        result.0?.forEach { category in
            AssignmentGroupsService.assignmentGroups.append(category)
        }
        return result
    }
}
