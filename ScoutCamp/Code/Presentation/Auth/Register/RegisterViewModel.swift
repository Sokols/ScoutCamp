//
//  RegisterViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import Combine

struct RegisterViewModelActions { 
    let goBackToLoginScreen: () -> Void
    let showMainFlow: () -> Void
}

protocol RegisterViewModelInput {
    func signUp() async
    func goBackToLoginScreen()
}

protocol RegisterViewModelOutput: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }

    var isEmailValid: Bool { get }
    var isPasswordValid: Bool { get }
    var isConfirmPasswordValid: Bool { get }
    var canSubmit: Bool { get }
    var isSubmitClicked: Bool { get }

    var emailPrompt: String { get }
    var passwordPrompt: String { get }
    var confirmPasswordPrompt: String { get }

    var error: Error? { get set }
    var isLoading: Bool { get }
}

protocol RegisterViewModel: RegisterViewModelInput, RegisterViewModelOutput {}

final class DefaultRegisterViewModel: RegisterViewModel {

    private let actions: RegisterViewModelActions
    private let signUpUseCase: SignUpUseCase
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - OUTPUT

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var isEmailValid = false
    @Published var isPasswordValid = false
    @Published var isConfirmPasswordValid = false
    @Published var canSubmit = false
    @Published var isSubmitClicked = false

    @Published var error: Error?
    @Published var isLoading = false


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

    // MARK: - Init

    init(_ actions: RegisterViewModelActions, signUpUseCase: SignUpUseCase) {
        self.actions = actions
        self.signUpUseCase = signUpUseCase
        initObservables()
    }


    // MARK: - Private

    private func initObservables() {
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
}

extension DefaultRegisterViewModel {
    @MainActor
    func signUp() async {
        if !isSubmitClicked {
            isSubmitClicked = true
        }
        if !canSubmit {
            return
        }
        isLoading = true
        let requestValue = SignUpUseCaseRequestValue(
            email: email,
            password: password
        )
        if let error = await signUpUseCase.execute(requestValue: requestValue) {
            self.error = error
            isLoading = false
            return
        }
        isLoading = false
        actions.showMainFlow()
    }

    func goBackToLoginScreen() {
        actions.goBackToLoginScreen()
    }
}
