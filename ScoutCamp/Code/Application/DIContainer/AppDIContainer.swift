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

    // MARK: - Repositories

    func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository()
    }

    // MARK: - DIContainers of screens

    func makeAuthDIContainer() -> AuthDIContainer {
        let dependencies = AuthDIContainer.Dependencies(
            firebaseDataService: firebaseDataService
        )
        return AuthDIContainer(dependencies: dependencies)
    }

    func makeMainDIContainer() -> MainDIContainer {
        let dependencies = MainDIContainer.Dependencies(
            firebaseDataService: firebaseDataService
        )
        return MainDIContainer(dependencies: dependencies)
    }
}