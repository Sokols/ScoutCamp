//
//  TeamSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 23/11/2023.
//

import Foundation

struct TeamSheet: Hashable {
    let teamSheetId: String?    // nil means team sheet is not yet saved

    let sheet: CategorizationSheet

    let team: Team
    let category: Category

    let points: Double
    let isDraft: Bool

    let createdAt: Date
    let updatedAt: Date
}

extension TeamSheet {
    var doesAlreadyExist: Bool { teamSheetId != nil }
}
