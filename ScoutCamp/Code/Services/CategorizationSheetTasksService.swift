//
//  CategorizationSheetTasksService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol CategorizationSheetTasksServiceProtocol {
    func getCategorizationSheetTasks(for categorizationSheetId: String) async -> ResultArray<CategorizationSheetTask>
}

class CategorizationSheetTasksService: BaseService, CategorizationSheetTasksServiceProtocol {
    func getCategorizationSheetTasks(for categorizationSheetId: String) async -> ResultArray<CategorizationSheetTask> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.categorizationSheetTasks.rawValue)
            .whereField("categorizationSheetId", isEqualTo: categorizationSheetId)

        return await fetch(query: query)
    }
}
