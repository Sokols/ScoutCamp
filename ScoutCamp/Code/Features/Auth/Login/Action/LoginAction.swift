//
//  LoginAction.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import Foundation

struct LoginAction {

    var parameters: LoginRequest

    func call(completion: @escaping (LoginResponse) -> Void) {
        // TODO: Implement API call
        completion(LoginResponse(data: LoginResponseData(accessToken: "test", refreshToken: "test")))
    }
}
