//
//  TaskCategoriesService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation

protocol TaskCategoriesServiceProtocol {
    func getTaskCategories() async -> ResultArray<TaskCategory>
}

class TaskCategoriesService: BaseService, TaskCategoriesServiceProtocol {
    func getTaskCategories() async -> ResultArray<TaskCategory> {
        await getAll(collection: .taskCategories)
    }
}
