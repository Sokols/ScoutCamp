//
//  MyTeamsViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Combine

@MainActor
class MyTeamsViewModel: ObservableObject {

    private let teamsService: TeamServiceProtocol

    @Published var userTeams: [Team] = []
    @Published var error: Error?
    @Published var isLoading = false

    init(teamsService: TeamServiceProtocol) {
        self.teamsService = teamsService
    }

    func fetchMyTeams() async {
        isLoading = true
        let result = await teamsService.getUserTeams()
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let userTeams = result.0 {
            self.userTeams = userTeams
        }
    }
}
