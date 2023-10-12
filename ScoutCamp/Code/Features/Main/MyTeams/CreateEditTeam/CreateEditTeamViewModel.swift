//
//  CreateEditTeamViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Combine

class CreateEditTeamViewModel: ObservableObject {

    private let teamsService: TeamServiceProtocol
    private let teamToEdit: Team?

    @Published var userTeams: [Team] = []
    @Published var error: Error?
    @Published var isLoading = false
    @Published var newUpdatedTeam: Team?

    @Published var regiments: [Team] = []
    @Published var troops: [Team] = []

    @Published var selectedRegiment: DropdownOption?
    @Published var selectedTroop: DropdownOption?
    @Published var name: String = ""

    private var isInitialEditFlowCall: Bool

    var isActionAvailable: Bool {
        isRegimentValid && isTroopValid && isNameValid
    }
    var isEditFlow: Bool { teamToEdit != nil }

    private var isRegimentValid: Bool { selectedRegiment != nil }
    private var isTroopValid: Bool { selectedTroop != nil }
    private var isNameValid: Bool { !name.isEmpty }

    init(teamToEdit: Team?, teamsService: TeamServiceProtocol) {
        self.teamToEdit = teamToEdit
        self.teamsService = teamsService

        name = teamToEdit?.name ?? ""
        isInitialEditFlowCall = teamToEdit != nil
    }

    // MARK: - Fetch data

    @MainActor
    func fetchRegiments() async {
        isLoading = true
        let result = await teamsService.getRegiments()
        isLoading = false

        if let error = result.1 {
            self.error = error
        } else if let regiments = result.0 {
            self.regiments = regiments
            if self.isEditFlow {
                self.selectedRegiment = regiments.first { $0.id == teamToEdit?.regimentId }?.toDropdownOption()
            }
        }
    }

    @MainActor
    func fetchTroops() async {
        guard let regimentId = selectedRegiment?.key else { return }
        let result = await teamsService.getTroopsForRegiment(regimentId: regimentId)

        if let error = result.1 {
            self.error = error
        } else if let troops = result.0 {
            self.troops = troops
            if self.isInitialEditFlowCall {
                self.selectedTroop = troops.first { $0.id == teamToEdit?.troopId }?.toDropdownOption()
                self.isInitialEditFlowCall = false
            }
        }
    }

    // MARK: - Selections

    func selectRegiment(option: DropdownOption) {
        selectedRegiment = option
        selectedTroop = nil
    }

    func selectTroop(option: DropdownOption) {
        selectedTroop = option
    }

    // MARK: - Team operations

    func save() async {
        if isEditFlow {
            await updateTeam()
        } else {
            await createTeam()
        }
    }

    @MainActor
    private func updateTeam() async {
        guard let team = teamToEdit else { return }
        isLoading = true
        let result = await teamsService.updateTeam(
            team,
            regimentId: selectedRegiment?.key,
            troopId: selectedTroop?.key,
            name: name
        )
        isLoading = false
        if let error = result {
            self.error = error
        } else {
            self.newUpdatedTeam = teamToEdit
        }
    }

    @MainActor
    private func createTeam() async {
        guard let regimentId = selectedRegiment?.key,
              let troopId = selectedTroop?.key,
              !name.isEmpty else { return }
        isLoading = true
        let result = await teamsService.createTeam(
            regimentId: regimentId,
            troopId: troopId,
            name: name
        )
        isLoading = false

        if let error = result.1 {
            self.error = error
        } else if let newUpdatedTeam = result.0 {
            self.newUpdatedTeam = newUpdatedTeam
        }
    }
}
