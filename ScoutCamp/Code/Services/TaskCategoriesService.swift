//
//  AssignmentCategoriesService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

protocol AssignmentCategoriesServiceProtocol {
    func getAssignmentCategories() async -> ResultArray<AssignmentGroup>
}

class AssignmentCategoriesService: BaseService, AssignmentCategoriesServiceProtocol {
    func getAssignmentCategories() async -> ResultArray<AssignmentGroup> {
        await getAll(collection: .assignmentCategories)
    }
}
