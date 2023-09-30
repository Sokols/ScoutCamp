//
//  ContentView.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 11/06/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authService: AuthService

    var body: some View {
        NavigationView {
            Group {
                if authService.loggedInUser != nil {
                    MainContainer()
                } else {
                    LoginScreen(authService: authService)
                }
            }
            .transition(.move(edge: .bottom))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthService())
    }
}
