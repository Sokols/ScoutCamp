//
//  CategorizationHomeScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import SwiftUI

struct CategorizationHomeScreen: View {
    @EnvironmentObject private var assignmentsService: AssignmentsService
    @EnvironmentObject private var teamAssignmentsService: TeamCategorizationSheetAssignmentsService
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
                    if viewModel.currentPeriodSheetJunctions.isEmpty {
                        Text("No sheets.")
                            .multilineTextAlignment(.center)
                    } else {
                        CategorizationSheetsCarouselView(
                            assignmentsService: assignmentsService,
                            teamAssignmentsService: teamAssignmentsService,
                            junctions: $viewModel.currentPeriodSheetJunctions
                        )
                        .padding(.horizontal, -16)
                    }
                }

                Text("Old sheets")
                    .font(.title)
                    .padding(.vertical)

                Group {
                    if viewModel.oldTeamSheetJunctions.isEmpty {
                        Text("No sheets.")
                            .multilineTextAlignment(.center)
                    } else {
                        List {
                            ForEach(viewModel.oldTeamSheetJunctions, id: \.self) { item in
                                NavigationLink(destination: CategorizationSheetScreen(
                                    sheetJunction: item,
                                    assignmentsService: assignmentsService,
                                    teamAssignmentsService: teamAssignmentsService
                                )) {
                                    CategorizationSheetItemView(
                                        item: item,
                                        categoryUrl: viewModel.getUrlForCategoryId(
                                            item.teamCategorizationSheet?.categoryId ?? ""
                                        )
                                    )
                                }
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
        }
        .padding(.horizontal, 16)
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .onLoad {
            Task {
                await viewModel.fetchInitData()
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
            teamSheetsService: TeamCategorizationSheetsService(),
            storageManager: StorageManager()
        )
    }
}
