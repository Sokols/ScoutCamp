//
//  SheetType.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct SheetType: FirebaseModel, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let order: Int
}
