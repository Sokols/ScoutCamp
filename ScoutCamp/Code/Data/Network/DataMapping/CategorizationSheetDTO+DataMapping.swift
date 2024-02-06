//
//  CategorizationSheet+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension CategorizationSheetDTO {
    func toDomain() -> CategorizationSheet? {
        guard let period = CategorizationPeriodsService.categoryPeriodFor(id: self.periodId)?.toDomain(),
              let sheetType = SheetTypesService.sheetTypeFor(id: self.sheetTypeId)?.toDomain() else { return nil }

        return CategorizationSheet(
            sheetId: self.id,
            period: period,
            sheetType: sheetType
        )
    }
}
