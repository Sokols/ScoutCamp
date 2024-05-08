//
//  MyTeamsScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import SwiftUI

struct MyTeamsScreen<T: MyTeamsViewModel>: View {
    @StateObject private var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                                .onTapGesture {
                                    viewModel.showMyTeamScreen(item)
                                }
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(PlainListStyle())
                    .padding(.vertical)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            FloatingActionButton()
                .onTapGesture {
                    viewModel.showMyTeamScreen(nil)
                }
        }
        .padding()
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
    }
}

struct MyTeamsScreen_Previews: PreviewProvider {
    class MockViewModel: MyTeamsViewModel {
        func onLoad() async {}
        func onAppear() async {}
        func showMyTeamScreen(_ team: Team?) {}

        var userTeams: [Team] = []
        var error: Error?
        var isLoading: Bool = false
    }

    private static var mockViewModel: MockViewModel = MockViewModel()

    static var previews: some View {
        MyTeamsScreen(viewModel: mockViewModel)
    }
}
