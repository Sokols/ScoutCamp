//
//  TeamCategoriationSheetsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol TeamCategoriationSheetsServiceProtocol {
    func getTeamCategorizationSheets(for teamId: String) async -> ResultArray<TeamCategorizationSheet>
}

class TeamCategoriationSheetsService: BaseService, TeamCategoriationSheetsServiceProtocol {
    func getTeamCategorizationSheets(for teamId: String) async -> ResultArray<TeamCategorizationSheet> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teamCategorizationSheets.rawValue)
            .whereField("teamId", isEqualTo: teamId)

        return await fetch(query: query)
    }
}
