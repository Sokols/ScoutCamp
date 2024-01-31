//
//  AppDelegate.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/11/2023.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        setupServiceContainer()
        RemoteConfigManager.shared.setup()
        return true
    }
}

private extension AppDelegate {
    func setupServiceContainer() {
        ServiceContainer.register(type: TeamsServiceProtocol.self, TeamsService())
        ServiceContainer.register(type: AuthServiceProtocol.self, AuthService())
        ServiceContainer.register(type: AssignmentGroupsServiceProtocol.self, AssignmentGroupsService())
        ServiceContainer.register(type: AssignmentGroupAssignmentJunctionsServiceProtocol.self, AssignmentGroupAssignmentJunctionsService())
        ServiceContainer.register(type: AssignmentGroupCategoryMinimumsServiceProtocol.self, AssignmentGroupCategoryMinimumsService())
        ServiceContainer.register(type: AssignmentsServiceProtocol.self, AssignmentsService())
        ServiceContainer.register(type: CategoriesServiceProtocol.self, CategoriesService())
        ServiceContainer.register(type: CategorizationPeriodsServiceProtocol.self, CategorizationPeriodsService())
        ServiceContainer.register(type: CategorizationSheetsServiceProtocol.self, CategorizationSheetsService())
        ServiceContainer.register(type: CategorizationSheetAssignmentsServiceProtocol.self, CategorizationSheetAssignmentsService())
        ServiceContainer.register(type: SheetTypesServiceProtocol.self, SheetTypesService())
        ServiceContainer.register(type: TeamCategorizationSheetsServiceProtocol.self, TeamCategorizationSheetsService())
        ServiceContainer.register(type: TeamCategorizationSheetAssignmentsServiceProtocol.self, TeamCategorizationSheetAssignmentsService())
        ServiceContainer.register(type: StorageManagerProtocol.self, StorageManager())
    }
}
