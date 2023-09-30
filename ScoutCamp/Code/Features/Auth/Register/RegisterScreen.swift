//
//  RegisterScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import SwiftUI

struct RegisterScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: RegisterViewModel
    @State private var showAlert = false

    init(authService: AuthService) {
        _viewModel = StateObject(
            wrappedValue: RegisterViewModel(authService: authService)
        )
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
                        await viewModel.register()
                    }
                })
                .buttonStyle(MainActionButton())
                .disabled(!viewModel.canSubmit)
                .opacity(viewModel.canSubmit ? 1.0 : 0.6)

                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Register.LoginNav.Title")
                        .foregroundColor(.white)
                })

            }
            .padding(32.0)
            .errorAlert(error: $viewModel.error)
        }
        .navigationBarHidden(true)
        .modifier(ActivityIndicatorModifier(isLoading: viewModel.isLoading))
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreen(authService: AuthService())
    }
}
