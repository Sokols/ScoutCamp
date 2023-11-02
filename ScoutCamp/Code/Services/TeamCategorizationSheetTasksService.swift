//
//  TeamCategorizationSheetTasksService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol TeamCategorizationSheetTasksServiceProtocol {
    func getTeamCategorizationSheetTasks(for teamCategorizationSheetId: String) async -> ResultArray<TeamCategorizationSheetTask> 
}

class TeamCategorizationSheetTasksService: BaseService, TeamCategorizationSheetTasksServiceProtocol {
    func getTeamCategorizationSheetTasks(for teamCategorizationSheetId: String) async -> ResultArray<TeamCategorizationSheetTask> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheetTasks.rawValue)
            .whereField("teamCategorizationSheetId", isEqualTo: teamCategorizationSheetId)

        return await fetch(query: query)
    }
}
