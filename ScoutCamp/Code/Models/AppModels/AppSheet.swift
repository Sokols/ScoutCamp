//
//  AppSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/11/2023.
//

import Foundation

struct AppSheet: Hashable {
    let sheetId: String
    let period: CategorizationPeriod
    let sheetType: SheetType
}

extension AppSheet {
    static func from(sheet: CategorizationSheet) -> AppSheet {
        let period = CategorizationPeriodsService.categoryPeriodFor(id: sheet.periodId)
        let sheetType = SheetTypesService.sheetTypeFor(id: sheet.sheetTypeId)

        return AppSheet(
            sheetId: sheet.id,
            period: period!,
            sheetType: sheetType!
        )
    }
}
