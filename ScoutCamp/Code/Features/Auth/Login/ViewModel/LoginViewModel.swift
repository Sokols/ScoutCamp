//
//  LoginViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import Combine

class LoginViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isUsernameValid = false
    @Published var isPasswordValid = false
    @Published var canSubmit = false
    @Published var isSubmitClicked = false

    @Published var error: Error?

    private var cancellables: Set<AnyCancellable> = []

    var usernamePrompt: String {
        isUsernameValid || !isSubmitClicked ? "" : "Validation.Field.CannotBeEmpty".localized
    }
    var passwordPrompt: String {
        isPasswordValid || !isSubmitClicked ? "" : "Validation.Field.CannotBeEmpty".localized
    }

    init() {
        $username
            .map { Validation.isRequiredFieldValid($0) }
            .assign(to: \.isUsernameValid, on: self)
            .store(in: &cancellables)

        $password
            .map { Validation.isRequiredFieldValid($0) }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        $isSubmitClicked
            .map { !$0 || (self.isUsernameValid && self.isPasswordValid) }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest($isUsernameValid, $isPasswordValid)
            .map { [$0, $1].allSatisfy({ $0 }) || !self.isSubmitClicked }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func login() {
        if !isSubmitClicked {
            isSubmitClicked = true
        }
        if !canSubmit {
            return
        }
        LoginAction(
            parameters: LoginRequest(
                username: username,
                password: password
            )
        ).call { _ in
            // TODO: Login successful, navigate to the Home screen
            self.error = Error.generalError
        }
    }
}
