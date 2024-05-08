//
//  CategoryDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

struct CategoryDTO: FirebaseModel {
    let id: String
    let name: String
    let imagePath: String
    let order: Int
}
