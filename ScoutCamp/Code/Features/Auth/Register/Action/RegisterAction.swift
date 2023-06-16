//
//  RegisterAction.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import Foundation

struct RegisterAction {

    var parameters: RegisterRequest

    func call(completion: @escaping (RegisterResponse) -> Void) {
        // TODO: Implement API call
        completion(RegisterResponse(data: RegisterResponseData()))
    }
}
