//
//  RegisterViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {

    private let authService: AuthService

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var isEmailValid = false
    @Published var isPasswordValid = false
    @Published var isConfirmPasswordValid = false
    @Published var canSubmit = false
    @Published var isSubmitClicked = false

    @Published var error: Error?

    private var cancellables: Set<AnyCancellable> = []

    var emailPrompt: String {
        isEmailValid || !isSubmitClicked ? "" : "Validation.Email.Invalid"
    }
    var passwordPrompt: String {
        isPasswordValid || !isSubmitClicked ? "" : "Validation.Field.MinCharacters"
            .localized(arguments: Validation.passwordMinChars.description)
    }
    var confirmPasswordPrompt: String {
        isConfirmPasswordValid || !isSubmitClicked ? "" : "Validation.Password.MustMatch"
    }

    init(_ authService: AuthService = AuthService()) {
        self.authService = authService
        $email
            .map { Validation.isEmailValid($0) }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)

        $password
            .map { Validation.isPasswordCharsNumberValid($0) }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest($password, $confirmPassword)
            .map { $0 == $1 && $0 != "" }
            .assign(to: \.isConfirmPasswordValid, on: self)
            .store(in: &cancellables)

        $isSubmitClicked
            .map { !$0 || (self.isEmailValid && self.isPasswordValid && self.isConfirmPasswordValid) }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest3($isEmailValid, $isPasswordValid, $isConfirmPasswordValid)
            .map { [$0, $1, $2].allSatisfy({ $0 }) || !self.isSubmitClicked }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func register(completion: @escaping CheckCompletion) {
        if !isSubmitClicked {
            isSubmitClicked = true
        }
        if !canSubmit {
            completion(false, nil)
            return
        }
        authService.createUser(email: email, password: password) { [weak self] isSuccess, error in
            self?.error = error
            completion(isSuccess, error)
        }
    }
}
