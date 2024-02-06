//
//  CategorizationSheetDTO.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

struct CategorizationSheetDTO: FirebaseModel {
    let id: String

    let periodId: String
    let sheetTypeId: String
}
