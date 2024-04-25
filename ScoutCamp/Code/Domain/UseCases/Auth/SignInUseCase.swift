//
//  SignInUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 19/02/2024.
//

import Foundation

protocol SignInUseCase {
    func execute(requestValue: SignInUseCaseRequestValue) async -> Error?
}

final class DefaultSignInUseCase: SignInUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(requestValue: SignInUseCaseRequestValue) async -> Error? {
        return await authRepository.signIn(
            email: requestValue.email,
            password: requestValue.password
        )
    }
}

struct SignInUseCaseRequestValue {
    let email: String
    let password: String
}
