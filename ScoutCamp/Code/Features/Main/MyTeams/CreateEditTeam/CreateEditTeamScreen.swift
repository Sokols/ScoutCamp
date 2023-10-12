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

    init(teamToEdit: Team?) {
        _viewModel = StateObject(
            wrappedValue: CreateEditTeamViewModel(teamToEdit: teamToEdit, teamsService: TeamsService())
        )
    }

    var body: some View {
        VStack(spacing: 16) {

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

            Button(viewModel.isEditFlow ? "Save" : "Create") {
                Task { await viewModel.save() }
            }
            .disabled(!viewModel.isActionAvailable)
            .buttonStyle(MainActionButton(isDisabled: !viewModel.isActionAvailable))
        }
        .padding()
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchRegiments()
            }
        }
        .onChange(of: viewModel.selectedRegiment) { _ in
            Task {
                await viewModel.fetchTroops()
            }
        }
        .onChange(of: viewModel.newUpdatedTeam) { newValue in
            if newValue != nil {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CreateEditTeamScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateEditTeamScreen(teamToEdit: nil)
    }
}
