//
//  TeamsService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol TeamServiceProtocol {
    func getRegiments() async -> ResultArray<Team>
    func getTroopsForRegiment(regimentId: String) async -> ResultArray<Team>
    func getTeamsForTroop(troopId: String) async -> ResultArray<Team>
    func getUserTeams() async -> ResultArray<Team>
}

class TeamsService: BaseService, TeamServiceProtocol {

    // MARK: - Teams, Troops & Regiments

    func getRegiments() async -> ResultArray<Team> {
        return await getAll(collection: .regiments)
    }

    func getTroopsForRegiment(regimentId: String) async -> ResultArray<Team> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.troops.rawValue)
            .whereField("regimentId", isEqualTo: regimentId)

        return await fetch(query: query)
    }

    func getTeamsForTroop(troopId: String) async -> ResultArray<Team> {
        let query = Firestore.firestore()
            .collection(FirebaseCollection.teams.rawValue)
            .whereField("troopId", isEqualTo: troopId)

        return await fetch(query: query)
    }

    func getUserTeams() async -> ResultArray<Team> {
        return await getUserItems(
            collection: .teams,
            orderBy: "name"
        )
    }
}
