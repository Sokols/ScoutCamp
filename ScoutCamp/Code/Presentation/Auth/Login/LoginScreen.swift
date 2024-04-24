//
//  LoginScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import SwiftUI

struct LoginScreen<T: LoginViewModel>: View {
    @StateObject private var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.backgroundColor, .secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()
                VStack {
                    Spacer()

                    Text("General.AppName".localized.uppercased()).foregroundColor(.primaryColor)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .scaledToFill()

                    Spacer()

                    Image(systemName: "person.text.rectangle.fill")
                        .font(.system(size: 128))
                        .foregroundColor(Color.primaryColor)
                        .shadow(radius: 4, y: 4)

                    Spacer()

                    VStack(spacing: 24) {
                        EntryField(
                            symbolName: "person.fill",
                            placeholder: "Login.EmailField.Title",
                            prompt: viewModel.emailPrompt,
                            field: $viewModel.email
                        )
                        .keyboardType(.emailAddress)
                        EntryField(
                            symbolName: "lock.fill",
                            placeholder: "Login.PasswordField.Title",
                            prompt: viewModel.passwordPrompt,
                            field: $viewModel.password,
                            isSecure: true
                        )
                    }

                    Spacer()

                    Button("Login.LoginButton.Title", action: {
                        Task {
                            await viewModel.signIn()
                        }
                    })
                    .buttonStyle(MainActionButton())

                    Spacer()
                    Text("Login.RegisterNav.Title")
                        .foregroundColor(.white)
                        .onTapGesture {
                            Task {
                                viewModel.showRegisterScreen()
                            }
                        }
                }
                .padding(32.0)
            }
        }
        .errorAlert(error: $viewModel.error)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
    }
}

struct LoginScreen_Previews: PreviewProvider {
    class MockViewModel: LoginViewModel {
        func signIn() async {}
        func showRegisterScreen() {}
        
        var email: String = ""
        var password: String = ""
        var isEmailValid: Bool = false
        var isPasswordValid: Bool = false
        var canSubmit: Bool = false
        var isSubmitClicked: Bool = false
        var emailPrompt: String = ""
        var passwordPrompt: String = ""
        var error: Error?
        var isLoading: Bool = false
    }

    private static var mockViewModel: MockViewModel = MockViewModel()

    static var previews: some View {
        LoginScreen(viewModel: mockViewModel)
    }
}
