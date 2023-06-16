//
//  LoginRequest.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}
