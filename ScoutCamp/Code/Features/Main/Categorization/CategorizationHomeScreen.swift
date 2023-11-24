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
            wrappedValue: CategorizationHomeViewModel( )
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
                    if viewModel.currentSheets.isEmpty {
                        Text("No sheets.")
                            .multilineTextAlignment(.center)
                    } else {
                        CategorizationSheetsCarouselView(sheets: $viewModel.currentSheets)
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
                                NavigationLink(destination: CategorizationSheetScreen(sheet: item)) {
                                    CategorizationSheetItemView(item: item)
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
        CategorizationHomeScreen()
    }
}
