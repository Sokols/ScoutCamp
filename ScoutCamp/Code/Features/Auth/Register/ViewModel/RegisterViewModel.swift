//
//  RegisterViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var isEmailValid = false
    @Published var isUsernameValid = false
    @Published var isPasswordValid = false
    @Published var isConfirmPasswordValid = false
    @Published var canSubmit = false
    @Published var isSubmitClicked = false

    @Published var error: Error?

    private var cancellables: Set<AnyCancellable> = []

    var emailPrompt: String {
        isEmailValid || !isSubmitClicked ? "" : "Validation.Email.Invalid"
    }
    var usernamePrompt: String {
        isUsernameValid || !isSubmitClicked ? "" : "Validation.Field.MinCharacters"
            .localized(arguments: Validation.usernameMinChars.description)
    }
    var passwordPrompt: String {
        isPasswordValid || !isSubmitClicked ? "" : "Validation.Field.MinCharacters"
            .localized(arguments: Validation.passwordMinChars.description)
    }
    var confirmPasswordPrompt: String {
        isConfirmPasswordValid || !isSubmitClicked ? "" : "Validation.Password.MustMatch"
    }

    init() {
        $email
            .map { Validation.isEmailValid($0) }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)

        $username
            .map { Validation.isUsernameCharsNumberValid($0) }
            .assign(to: \.isUsernameValid, on: self)
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
            .map { !$0 || (self.isEmailValid && self.isUsernameValid
                && self.isPasswordValid && self.isConfirmPasswordValid) }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)

        Publishers.CombineLatest4($isEmailValid, $isUsernameValid, $isPasswordValid, $isConfirmPasswordValid)
            .map { [$0, $1, $2, $3].allSatisfy({ $0 }) || !self.isSubmitClicked }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellables)
    }

    func register() {
        if !isSubmitClicked {
            isSubmitClicked = true
        }
        if !canSubmit {
            return
        }
        RegisterAction(
            parameters: RegisterRequest(
                email: email,
                username: username,
                password: password
            )
        ).call { _ in
            // TODO: Implement proper register completion
            self.error = Error.generalError
        }
    }
}
