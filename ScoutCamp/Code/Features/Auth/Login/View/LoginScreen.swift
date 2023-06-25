//
//  LoginScreen.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import SwiftUI

struct LoginScreen: View {

    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()

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
                        EntryField(symbolName: "person.fill",
                                   placeholder: "Login.UsernameField.Title",
                                   prompt: viewModel.usernamePrompt,
                                   field: $viewModel.username)
                        EntryField(symbolName: "lock.fill",
                                   placeholder: "Login.PasswordField.Title",
                                   prompt: viewModel.passwordPrompt,
                                   field: $viewModel.password,
                                   isSecure: true)
                    }
                    
                    Spacer()

                    Button("Login.LoginButton.Title", action: viewModel.login)
                        .buttonStyle(MainActionButton())

                    Spacer()

                    NavigationLink(destination: RegisterScreen()) {
                        Text("Login.RegisterNav.Title")
                            .foregroundColor(.white)
                    }
                }
                .padding(32.0)
                .errorAlert(error: $viewModel.error)
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
