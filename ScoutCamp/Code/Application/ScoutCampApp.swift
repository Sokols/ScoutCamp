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
        return true
    }
}

@main
struct ScoutCampApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authService = AuthService()
    @StateObject private var categoriesService = CategoriesService()
    @StateObject private var categorizationPeriodsService = CategorizationPeriodsService()
    @StateObject private var categorizationSheetsService = CategorizationSheetsService()
    @StateObject private var categorizationSheetTasksService = CategorizationSheetTasksService()
    @StateObject private var categorizationTasksService = CategorizationTasksService()
    @StateObject private var sheetTypesService = SheetTypesService()
    @StateObject private var taskCategoriesService = TaskCategoriesService()
    @StateObject private var teamsService = TeamsService()
    @StateObject private var teamCategorizationSheetsService = TeamCategorizationSheetsService()
    @StateObject private var teeamCategorizationSheetTasksService = TeamCategorizationSheetTasksService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .environmentObject(categoriesService)
                .environmentObject(categorizationPeriodsService)
                .environmentObject(categorizationSheetsService)
                .environmentObject(categorizationSheetTasksService)
                .environmentObject(categorizationTasksService)
                .environmentObject(sheetTypesService)
                .environmentObject(taskCategoriesService)
                .environmentObject(teamsService)
                .environmentObject(teamCategorizationSheetsService)
                .environmentObject(teeamCategorizationSheetTasksService)
        }
    }
}
