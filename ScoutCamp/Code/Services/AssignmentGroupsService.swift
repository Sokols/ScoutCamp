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

class AssignmentGroupsService: BaseService, AssignmentGroupsServiceProtocol {
    func getAssignmentGroups() async -> ResultArray<AssignmentGroup> {
        await getAll(collection: .assignmentGroups)
    }
}
