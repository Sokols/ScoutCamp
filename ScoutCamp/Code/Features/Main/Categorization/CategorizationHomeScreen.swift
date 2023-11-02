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
        teamSheetsService: TeamCategorizationSheetsServiceProtocol,
        storageManager: StorageManagerProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: CategorizationHomeViewModel(
                teamsService: teamsService,
                teamSheetsService: teamSheetsService,
                storageManager: storageManager
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

                Text("Current sheets for period: \(viewModel.currentPeriod?.name ?? "")")
                    .font(.title)
                    .padding(.vertical)

                Group {
                    if viewModel.currentPeriodTeamSheets.isEmpty {
                        Text("No sheets.")
                            .multilineTextAlignment(.center)
                    } else {
                        CategorizationSheetsCarouselView(sheets: $viewModel.currentPeriodTeamSheets)
                            .padding(.horizontal, -16)
                    }
                }

                Text("Old sheets")
                    .font(.title)
                    .padding(.vertical)

                Group {
                    if viewModel.oldTeamSheets.isEmpty {
                        Text("No sheets.")
                            .multilineTextAlignment(.center)
                    } else {
                        List {
                            ForEach(viewModel.oldTeamSheets, id: \.self) { item in
                                CategorizationSheetItemView(
                                    item: item,
                                    categoryUrl: viewModel.getUrlForCategoryId(item.categoryId)
                                )
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
        .padding(.horizontal, 16)
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .task {
            await viewModel.fetchMyTeams()
        }
        .task {
            await viewModel.fetchMySheets()
        }
        .task {
            await viewModel.fetchCategoryUrls()
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
            teamSheetsService: TeamCategorizationSheetsService(),
            storageManager: StorageManager()
        )
    }
}
