//
//  TasksService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol CategorizationTasksServiceProtocol {
    func getCategorizationTasks() async -> ResultArray<CategorizationTask>
}

class CategorizationTasksService: BaseService, CategorizationTasksServiceProtocol {
    func getCategorizationTasks() async -> ResultArray<CategorizationTask> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.categorizationTasks.rawValue)
            .order(by: "order")

        return await fetch(query: query)
    }
}
