//
//  LoginViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import Combine

class LoginViewModel: ObservableObject {

    private let authService: AuthService

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isEmailValid = false
    @Published var isPasswordValid = false
    @Published var canSubmit = false
    @Published var isSubmitClicked = false

    @Published var error: Error?

    private var cancellables: Set<AnyCancellable> = []

    var emailPrompt: String {
        isEmailValid || !isSubmitClicked ? "" : "Validation.Email.Invalid".localized
    }
    var passwordPrompt: String {
        isPasswordValid || !isSubmitClicked ? "" : "Validation.Field.CannotBeEmpty".localized
    }

    init(authService: AuthService) {
        self.authService = authService
        $email
            .map { Validation.isEmailValid($0) }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)

        $password
            .map { Validation.isRequiredFieldValid($0) }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        $isSubmitClicked
            .map { !$0 || (self.isEmailValid && self.isPasswordValid) }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest($isEmailValid, $isPasswordValid)
            .map { [$0, $1].allSatisfy({ $0 }) || !self.isSubmitClicked }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func signIn() {
        if !isSubmitClicked {
            isSubmitClicked = true
        }
        if !canSubmit {
            return
        }
        authService.signIn(email: email, password: password) { [weak self] error in
            self?.error = error
        }
    }
}
