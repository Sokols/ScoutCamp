//
//  SettingsScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 28/08/2023.
//

import SwiftUI

struct SettingsScreen: View {
    @StateObject private var viewModel: SettingsViewModel

    init(authService: AuthService) {
        _viewModel = StateObject(
            wrappedValue: SettingsViewModel(authService: authService)
        )
    }

    var body: some View {
        Button("Settings.Logout".localized, action: viewModel.logOut)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(authService: AuthService())
    }
}
