//
//  SignOutUseCase.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/04/2024.
//

import Foundation

protocol SignOutUseCase {
    func execute() -> Error?
}

final class DefaultSignOutUseCase: SignOutUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() -> Error? {
        return authRepository.signOut()
    }
}
