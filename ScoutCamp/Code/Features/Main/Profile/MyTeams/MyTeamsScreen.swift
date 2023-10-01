//
//  MyTeamsScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import SwiftUI

struct MyTeamsScreen: View {
    @StateObject private var viewModel: MyTeamsViewModel

    init() {
        _viewModel = StateObject(
            wrappedValue: MyTeamsViewModel(teamsService: TeamsService())
        )
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("My teams")
                .font(.largeTitle)

            if viewModel.userTeams.isEmpty {
                Spacer()
                Text("You don't have any teams yet.\nTry to add new one!")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.userTeams) { item in
                        Text(item.name)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .padding(.vertical)
            }

            Spacer()
        }
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchMyTeams()
            }
        }
    }
}

struct MyTeamsScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyTeamsScreen()
    }
}
