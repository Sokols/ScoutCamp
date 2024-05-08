//
//  CategorizationSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/11/2023.
//

import Foundation

struct CategorizationSheet: Hashable {
    let sheetId: String
    let period: CategorizationPeriod
    let sheetType: SheetType
}
