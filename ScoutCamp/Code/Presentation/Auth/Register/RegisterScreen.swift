//
//  RegisterScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

struct RegisterScreen<T: RegisterViewModel>: View {
    @StateObject private var viewModel: T
    @State private var showAlert = false

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.backgroundColor, .secondaryColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            VStack {
                Spacer()

                Text("Register.TitleText.Title".localized.uppercased()).foregroundColor(.primaryColor)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .scaledToFill()

                Spacer()

                VStack(spacing: 16) {
                    EntryField(symbolName: "envelope.fill",
                               placeholder: "Register.EmailField.Title",
                               prompt: viewModel.emailPrompt,
                               field: $viewModel.email)
                    .keyboardType(.emailAddress)
                    EntryField(symbolName: "lock.fill",
                               placeholder: "Register.PasswordField.Title",
                               prompt: viewModel.passwordPrompt,
                               field: $viewModel.password,
                               isSecure: true)
                    EntryField(symbolName: "lock.fill",
                               placeholder: "Register.ConfirmPasswordField.Title",
                               prompt: viewModel.confirmPasswordPrompt,
                               field: $viewModel.confirmPassword,
                               isSecure: true)
                }

                Spacer()

                Button("Register.RegisterButton.Title", action: {
                    Task {
                        await viewModel.signUp()
                    }
                })
                .buttonStyle(MainActionButton())
                .disabled(!viewModel.canSubmit)
                .opacity(viewModel.canSubmit ? 1.0 : 0.6)

                Spacer()

                Text("Register.RegisterNav.Title")
                    .foregroundColor(.white)
                    .onTapGesture {
                        Task {
                            viewModel.goBackToLoginScreen()
                        }
                    }
            }
            .padding(32.0)
            .errorAlert(error: $viewModel.error)
        }
        .navigationBarHidden(true)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    class MockViewModel: RegisterViewModel {
        func signUp() async {}
        func goBackToLoginScreen() {}

        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var isEmailValid: Bool = false
        var isPasswordValid: Bool = false
        var isConfirmPasswordValid: Bool = false
        var canSubmit: Bool = false
        var isSubmitClicked: Bool = false
        var emailPrompt: String = ""
        var passwordPrompt: String = ""
        var confirmPasswordPrompt: String = ""
        var error: Error?
        var isLoading: Bool = false
    }

    private static var mockViewModel: MockViewModel = MockViewModel()

    static var previews: some View {
        RegisterScreen(viewModel: mockViewModel)
    }
}
