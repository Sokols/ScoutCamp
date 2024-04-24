//
//  LoginViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import Combine

struct LoginViewModelActions {
    let showRegisterScreen: () -> Void
    let showMainFlow: () -> Void
}

protocol LoginViewModelInput {
    func signIn() async
    func showRegisterScreen()
}

protocol LoginViewModelOutput: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    
    var isEmailValid: Bool { get }
    var isPasswordValid: Bool { get }
    var canSubmit: Bool { get }
    var isSubmitClicked: Bool { get }

    var emailPrompt: String { get }
    var passwordPrompt: String { get }

    var error: Error? { get set }
    var isLoading: Bool { get }
}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {}

final class DefaultLoginViewModel: LoginViewModel {

    private let actions: LoginViewModelActions
    private let signInUseCase: SignInUseCase
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - OUTPUT

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isEmailValid = false
    @Published var isPasswordValid = false
    @Published var canSubmit = false
    @Published var isSubmitClicked = false

    @Published var error: Error?
    @Published var isLoading = false

    var emailPrompt: String {
        isEmailValid || !isSubmitClicked ? "" : "Validation.Email.Invalid".localized
    }
    var passwordPrompt: String {
        isPasswordValid || !isSubmitClicked ? "" : "Validation.Field.CannotBeEmpty".localized
    }

    // MARK: - Init

    init(_ actions: LoginViewModelActions, signInUseCase: SignInUseCase) {
        self.actions = actions
        self.signInUseCase = signInUseCase
        initObservables()
    }

    // MARK: - Private

    private func initObservables() {
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
}

extension DefaultLoginViewModel {
    @MainActor
    func signIn() async {
        if !isSubmitClicked {
            isSubmitClicked = true
        }
        if !canSubmit {
            return
        }
        isLoading = true
        let requestValue = SignInUseCaseRequestValue(
            email: email,
            password: password
        )
        if let error = await signInUseCase.execute(requestValue: requestValue) {
            self.error = error
            isLoading = false
            return
        }
        isLoading = false
        actions.showMainFlow()
    }

    func showRegisterScreen() {
        actions.showRegisterScreen()
    }
}
