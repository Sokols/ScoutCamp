//
//  CategorizationHomeScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import SwiftUI

struct CategorizationHomeScreen<T: CategorizationHomeViewModel>: View  {
    @StateObject private var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
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
                    .padding(.top)

                Group {
                    if viewModel.currentSheets.isEmpty {
                        Text("No sheets.")
                            .multilineTextAlignment(.center)
                    } else {
                        CategorizationSheetsCarouselView(
                            sheets: viewModel.currentSheets,
                            onItemClick: viewModel.showSheetScreen
                        )
                        .padding(.horizontal, -16)
                    }
                }

                Text("Old sheets")
                    .font(.title)
                    .padding(.vertical)

                Group {
                    if viewModel.oldSheets.isEmpty {
                        Text("No sheets.")
                            .multilineTextAlignment(.center)
                    } else {
                        List {
                            ForEach(viewModel.oldSheets, id: \.self) { item in
                                CategorizationSheetItemView(item: item)
                                    .onTapGesture {
                                        viewModel.showSheetScreen(item)
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
                await viewModel.onLoad()
            }
        }
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
        .onChange(of: viewModel.selectedTeam) { _ in
            Task {
                await viewModel.onTeamDidChange()
            }
        }
    }
}
