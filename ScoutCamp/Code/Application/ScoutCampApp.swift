//
//  ScoutCampApp.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 11/06/2023.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        RemoteConfigManager.shared.setup()
        return true
    }
}

@main
struct ScoutCampApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authService = AuthService()
    @StateObject private var assignmentGroupsService = AssignmentGroupsService()
    @StateObject private var assignmentGroupAssignmentJunctionsService = AssignmentGroupAssignmentJunctionsService()
    @StateObject private var assignmentsService = AssignmentsService()
    @StateObject private var categoriesService = CategoriesService()
    @StateObject private var categorizationPeriodsService = CategorizationPeriodsService()
    @StateObject private var categorizationSheetsService = CategorizationSheetsService()
    @StateObject private var sheetTypesService = SheetTypesService()
    @StateObject private var teamsService = TeamsService()
    @StateObject private var teamCategorizationSheetsService = TeamCategorizationSheetsService()
    @StateObject private var teeamCategorizationSheetAssignmentsService = TeamCategorizationSheetAssignmentsService()
    @StateObject private var storageManager = StorageManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .environmentObject(categoriesService)
                .environmentObject(assignmentGroupAssignmentJunctionsService)
                .environmentObject(categorizationPeriodsService)
                .environmentObject(categorizationSheetsService)
                .environmentObject(assignmentsService)
                .environmentObject(sheetTypesService)
                .environmentObject(assignmentGroupsService)
                .environmentObject(teamsService)
                .environmentObject(teamCategorizationSheetsService)
                .environmentObject(teeamCategorizationSheetAssignmentsService)
                .environmentObject(storageManager)
        }
    }
}
