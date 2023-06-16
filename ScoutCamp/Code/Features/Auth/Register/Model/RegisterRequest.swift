//
//  RegisterRequest.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import Foundation

struct RegisterRequest: Encodable {
    let email: String
    let username: String
    let password: String
}
