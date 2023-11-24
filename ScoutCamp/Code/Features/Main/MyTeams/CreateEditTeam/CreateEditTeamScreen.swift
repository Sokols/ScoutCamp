//
//  CreateEditTeamScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import SwiftUI

struct CreateEditTeamScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: CreateEditTeamViewModel
    @State private var showDeleteTeamAlert = false

    init(teamToEdit: Team?) {
        _viewModel = StateObject(
            wrappedValue: CreateEditTeamViewModel(teamToEdit: teamToEdit)
        )
    }

    var body: some View {
        VStack {
            BaseToolbarView()
                .padding(.bottom, 24)
            List {
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
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .task {
            fetchRegiments()
        }
        .onChange(of: viewModel.selectedRegiment) { _ in
            fetchTroops()
        }
        .onChange(of: viewModel.newUpdatedTeam) { _ in
            self.presentationMode.wrappedValue.dismiss()
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
            await viewModel.save()
        }
    }

    private func fetchRegiments() {
        Task {
            await viewModel.fetchRegiments()
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
    static var previews: some View {
        CreateEditTeamScreen(teamToEdit: TestData.team)
    }
}
