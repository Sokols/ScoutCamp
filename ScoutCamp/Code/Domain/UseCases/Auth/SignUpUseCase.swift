//
//  SignUpUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/04/2024.
//

import Foundation

protocol SignUpUseCase {
    func execute(requestValue: SignUpUseCaseRequestValue) async -> Error?
}

final class DefaultSignUpUseCase: SignUpUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(requestValue: SignUpUseCaseRequestValue) async -> Error? {
        return await authRepository.signUp(
            email: requestValue.email,
            password: requestValue.password
        )
    }
}

struct SignUpUseCaseRequestValue {
    let email: String
    let password: String
}
