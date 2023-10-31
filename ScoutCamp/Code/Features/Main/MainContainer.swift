//
//  MainContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import SwiftUI

struct MainContainer: View {
    @EnvironmentObject private var authService: AuthService
    @EnvironmentObject private var teamsService: TeamsService
    @EnvironmentObject private var teamSheetsService: TeamCategorizationSheetsService
    @EnvironmentObject private var sheetTypesService: SheetTypesService
    @EnvironmentObject private var categoriesService: CategoriesService
    @EnvironmentObject private var categorizationPeriodsService: CategorizationPeriodsService
    @EnvironmentObject private var categorizationSheetsService: CategorizationSheetsService
    @EnvironmentObject private var storageManager: StorageManager

    var body: some View {
        TabView {
            HomeScreen(
                sheetTypesService: sheetTypesService,
                categoriesService: categoriesService,
                categorizationPeriodsService: categorizationPeriodsService,
                categorizationSheetsService: categorizationSheetsService
            )
            .tabItem {
                Label("Home.Name".localized, systemImage: "house")
            }
            CategorizationHomeScreen(
                teamsService: teamsService,
                teamSheetsService: teamSheetsService,
                storageManager: storageManager
            )
            .tabItem {
                Label("Categorization", systemImage: "doc.on.doc")
            }
            MyTeamsScreen(teamsService: teamsService)
                .tabItem {
                    Label("My Teams", systemImage: "person.2.fill")
                }
            ZStack {
                ProfileScreen(authService: authService)
            }
            .tabItem {
                Label("Profile.Name".localized, systemImage: "person.crop.circle.fill")
            }
        }
    }
}

struct MainContainer_Previews: PreviewProvider {
    static var previews: some View {
        MainContainer()
            .environmentObject(AuthService())
            .environmentObject(TeamsService())
            .environmentObject(TeamCategorizationSheetsService())
            .environmentObject(SheetTypesService())
            .environmentObject(CategoriesService())
            .environmentObject(CategorizationPeriodsService())
            .environmentObject(CategorizationSheetsService())
            .environmentObject(StorageManager())
    }
}
