//
//  CategorizationHomeScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import SwiftUI

struct CategorizationHomeScreen: View {
    @StateObject private var viewModel: CategorizationHomeViewModel

    init(
        teamsService: TeamServiceProtocol,
        teamSheetsService: TeamCategorizationSheetsServiceProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: CategorizationHomeViewModel(
                teamsService: teamsService,
                teamSheetsService: teamSheetsService
            )
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                DropdownField(
                    title: "Current team",
                    placeholder: "Select team",
                    options: viewModel.userTeams.map { $0.toDropdownOption() },
                    selectedOption: $viewModel.selectedTeam,
                    onOptionSelected: viewModel.selectTeam
                )
                .zIndex(1)

                Text("My sheets")
                    .font(.title)
                    .padding(.vertical)

                Group {
                    if viewModel.teamSheets.isEmpty {
                        Text("This team doesn't have any categorization sheets yet. Try to fill one!")
                            .multilineTextAlignment(.center)
                    } else {
                        List {
                            ForEach(viewModel.teamSheets, id: \.self) { item in
                                CategorizationSheetItemView(item: item)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .padding(.vertical)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if let team = viewModel.getTeam() {
                NavigationLink(destination: CategorizationSheetScreen(team: team)) {
                    FloatingActionButton()
                }
            }
        }
        .padding()
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .onLoad {
            Task {
                await viewModel.fetchMyTeams()
            }
            Task {
                await viewModel.fetchMySheets()
            }
        }
        .onChange(of: viewModel.selectedTeam) { _ in
            Task {
                await viewModel.fetchMySheets()
            }
        }
    }
}

struct CategorizationHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategorizationHomeScreen(
            teamsService: TeamsService(),
            teamSheetsService: TeamCategorizationSheetsService()
        )
    }
}
