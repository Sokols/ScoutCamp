//
//  AppDIContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/02/2024.
//

import Foundation

final class AppDIContainer {

    // MARK: - Network

    lazy var firebaseDataService: FirebaseDataService = DefaultFirebaseDataService()

    // MARK: - DIContainers of screens

    func makeCategorizationDIContainer() -> CategorizationDIContainer {
        let dependencies = CategorizationDIContainer.Dependencies(
            firebaseDataService: firebaseDataService
        )
        return CategorizationDIContainer(dependencies: dependencies)
    }
}
