//
//  CreateEditTeamViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Combine

struct CreateEditTeamViewModelActions {
    let navigateBack: () -> Void
}

protocol CreateEditTeamViewModelInput {
    func onLoad() async
    func fetchTroops() async
    func selectRegiment(option: DropdownOption)
    func selectTroop(option: DropdownOption)
    func saveTeam() async
    func deleteTeam() async
}

protocol CreateEditTeamViewModelOutput: ObservableObject {
    var error: Error? { get set }
    var isLoading: Bool { get }
    var regiments: [Team] { get }
    var troops: [Team] { get }
    var selectedRegiment: DropdownOption? { get set }
    var selectedTroop: DropdownOption? { get set }
    var name: String { get set }
    var isEditFlow: Bool { get }
    var isActionAvailable: Bool { get }
}

protocol CreateEditTeamViewModel: CreateEditTeamViewModelInput, CreateEditTeamViewModelOutput {}

struct CreateEditTeamViewModelUseCases {
    let fetchRegimentsUseCase: FetchRegimentsUseCase
    let fetchRegimentTroopsUseCase: FetchRegimentTroopsUseCase
    let createTeamUseCase: CreateTeamUseCase
    let updateTeamUseCase: UpdateTeamUseCase
    let deleteTeamUseCase: DeleteTeamUseCase
}

final class DefaultCreateEditTeamViewModel: CreateEditTeamViewModel {

    private let teamToEdit: Team?
    private let useCases: CreateEditTeamViewModelUseCases
    private let actions: CreateEditTeamViewModelActions

    private var isInitialEditFlowCall: Bool
    private var isRegimentValid: Bool { selectedRegiment != nil }
    private var isTroopValid: Bool { selectedTroop != nil }
    private var isNameValid: Bool { !name.isEmpty }

    // MARK: - OUTPUT

    @Published var error: Error?
    @Published var isLoading = false
    @Published var regiments: [Team] = []
    @Published var troops: [Team] = []
    @Published var selectedRegiment: DropdownOption?
    @Published var selectedTroop: DropdownOption?
    @Published var name: String = ""

    var isActionAvailable: Bool {
        isRegimentValid && isTroopValid && isNameValid
    }

    var isEditFlow: Bool { teamToEdit != nil }

    // MARK: - Init

    init(
        teamToEdit: Team?,
        useCases: CreateEditTeamViewModelUseCases,
        actions: CreateEditTeamViewModelActions
    ) {
        self.teamToEdit = teamToEdit
        self.useCases = useCases
        self.actions = actions

        name = teamToEdit?.name ?? ""
        isInitialEditFlowCall = teamToEdit != nil
    }

    // MARK: - Fetch data

    @MainActor
    func fetchTroops() async {
        guard let regimentId = selectedRegiment?.key else { return }
        let requestValue = FetchRegimentTroopsUseCaseRequestValue(regimentId: regimentId)
        let result = await useCases.fetchRegimentTroopsUseCase.execute(requestValue: requestValue)

        switch result {
        case .success(let troops):
            self.troops = troops
            if self.isInitialEditFlowCall {
                self.selectedTroop = self.troops.first { $0.id == teamToEdit?.troopId }?.toDropdownOption()
                self.isInitialEditFlowCall = false
            }
        case .failure(let failure):
            self.error = failure
        }
    }

    // MARK: - Team operations

    @MainActor
    func deleteTeam() async {
        guard let team = teamToEdit else { return }

        isLoading = true
        let requestValue = DeleteTeamUseCaseRequestValue(teamId: team.id)
        let error = await useCases.deleteTeamUseCase.execute(requestValue: requestValue)
        isLoading = false

        if let error {
            self.error = error
        } else {
            actions.navigateBack()
        }
    }

    @MainActor
    private func fetchRegiments() async {
        isLoading = true
        let result = await useCases.fetchRegimentsUseCase.execute()
        isLoading = false

        switch result {
        case .success(let regiments):
            self.regiments = regiments
            if self.isEditFlow {
                self.selectedRegiment = self.regiments.first { $0.id == teamToEdit?.regimentId }?.toDropdownOption()
            }
        case .failure(let failure):
            self.error = failure
        }
    }

    @MainActor
    private func updateTeam() async {
        guard let team = teamToEdit else { return }
        isLoading = true
        let requestValue = UpdateTeamUseCaseRequestValue(
            team: team,
            regimentId: selectedRegiment?.key,
            troopId: selectedTroop?.key,
            name: name
        )
        let result = await useCases.updateTeamUseCase.execute(requestValue: requestValue)
        isLoading = false

        if let error = result {
            self.error = error
        } else {
            actions.navigateBack()
        }
    }

    @MainActor
    private func createTeam() async {
        guard let regimentId = selectedRegiment?.key,
              let troopId = selectedTroop?.key,
              !name.isEmpty else { return }

        isLoading = true
        let requestValue = CreateTeamUseCaseRequestValue(
            regimentId: regimentId,
            troopId: troopId,
            name: name
        )
        let result = await useCases.createTeamUseCase.execute(requestValue: requestValue)
        isLoading = false

        switch result {
        case .success:
            actions.navigateBack()
        case .failure(let failure):
            self.error = failure
        }
    }
}

// MARK: - Input
extension DefaultCreateEditTeamViewModel {
    func onLoad() async {
        await fetchRegiments()
    }

    func saveTeam() async {
        if isEditFlow {
            await updateTeam()
        } else {
            await createTeam()
        }
    }

    func selectRegiment(option: DropdownOption) {
        selectedRegiment = option
        selectedTroop = nil
    }

    func selectTroop(option: DropdownOption) {
        selectedTroop = option
    }
}
