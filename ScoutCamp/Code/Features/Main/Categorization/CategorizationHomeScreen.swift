//
//  CategorizationHomeScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import SwiftUI

struct CategorizationHomeScreen: View {
    @StateObject private var viewModel: CategorizationHomeViewModel

    init() {
        _viewModel = StateObject(
            wrappedValue: CategorizationHomeViewModel(teamsService: TeamsService())
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 24) {
                Text("My sheets")
                    .font(.largeTitle)

                DropdownField(
                    title: "Current team",
                    placeholder: "Select team",
                    options: viewModel.userTeams.map { $0.toDropdownOption() },
                    selectedOption: $viewModel.selectedTeam,
                    onOptionSelected: viewModel.selectTeam
                )
                .zIndex(1)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()

            if let team = viewModel.getTeam() {
                NavigationLink(destination: CategorizationSheetScreen(team: team)) {
                    FloatingActionButton()
                }
            }
        }
        .padding()
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .onAppear {
            Task {
                await viewModel.fetchMyTeams()
            }
        }
    }
}

struct CategorizationHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategorizationHomeScreen()
    }
}
