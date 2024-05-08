//
//  CreateEditTeamScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import SwiftUI

struct CreateEditTeamScreen<T: CreateEditTeamViewModel>: View {
    @StateObject private var viewModel: T
    @State private var showDeleteTeamAlert = false

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            BaseToolbarView()
                .padding(.bottom, 24)
            ScrollView(showsIndicators: false) {
                Group {
                    DropdownField(
                        title: "Regiment",
                        placeholder: "Select regiment",
                        options: viewModel.regiments.map { $0.toDropdownOption() },
                        selectedOption: $viewModel.selectedRegiment,
                        onOptionSelected: viewModel.selectRegiment
                    )
                    .zIndex(2)

                    DropdownField(
                        title: "Troop",
                        placeholder: "Select troop",
                        options: viewModel.troops.map { $0.toDropdownOption() },
                        selectedOption: $viewModel.selectedTroop,
                        onOptionSelected: viewModel.selectTroop
                    )
                    .zIndex(1)

                    EntryField(
                        title: "Team name",
                        placeholder: "Name...",
                        prompt: "",
                        field: $viewModel.name
                    )

                    Button(viewModel.isEditFlow ? "Save" : "Create", action: saveTeam)
                        .disabled(!viewModel.isActionAvailable)
                        .buttonStyle(MainActionButton(isDisabled: !viewModel.isActionAvailable))

                    if viewModel.isEditFlow {
                        Button(action: onDeleteTeamClicked) {
                            Text("Delete Team")
                                .underline()
                                .padding(.top)
                        }
                        .modifier(CenterModifier())
                    }
                }
            }
            .padding(.horizontal)
        }
        .errorAlert(error: $viewModel.error)
        .navigationBarBackButtonHidden()
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .onLoad {
            Task {
                await viewModel.onLoad()
            }
        }
        .onChange(of: viewModel.selectedRegiment) { _ in
            fetchTroops()
        }
        .alert("Are you sure?", isPresented: $showDeleteTeamAlert) {
            Button("Yes", action: deleteTeam)
            Button("Cancel", role: .cancel) { showDeleteTeamAlert = false }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    // MARK: - Actions

    private func onDeleteTeamClicked() {
        showDeleteTeamAlert = true
    }

    // MARK: - Data operations

    private func saveTeam() {
        Task {
            await viewModel.saveTeam()
        }
    }

    private func fetchTroops() {
        Task {
            await viewModel.fetchTroops()
        }
    }

    private func deleteTeam() {
        Task {
            await viewModel.deleteTeam()
        }
    }
}

struct CreateEditTeamScreen_Previews: PreviewProvider {
    class MockViewModel: CreateEditTeamViewModel {
        func fetchTroops() async {}
        func selectRegiment(option: DropdownOption) {}
        func selectTroop(option: DropdownOption) {}
        func saveTeam() async {}
        func deleteTeam() async {}
        func onLoad() async {}

        var error: Error?
        var isLoading: Bool = false
        var regiments: [Team] = []
        var troops: [Team] = []
        var selectedRegiment: DropdownOption?
        var selectedTroop: DropdownOption?
        var name: String = ""
        var isEditFlow: Bool = false
        var isActionAvailable: Bool = false
    }

    private static var mockViewModel: MockViewModel = MockViewModel()

    static var previews: some View {
        CreateEditTeamScreen(viewModel: mockViewModel)
    }
}
