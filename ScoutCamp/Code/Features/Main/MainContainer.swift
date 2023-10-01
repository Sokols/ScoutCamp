//
//  MainContainer.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import SwiftUI

struct MainContainer: View {
    @EnvironmentObject private var authService: AuthService

    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Label("Home.Name".localized, systemImage: "house")
                }
            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            Text("Notification")
                .tabItem {
                    Label("Notification", systemImage: "bell")
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
    }
}
