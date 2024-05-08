//
//  CategorizationSheet+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension CategorizationSheetDTO {
    func toDomain(period: CategorizationPeriod, sheetType: SheetType) -> CategorizationSheet {
        return CategorizationSheet(
            sheetId: self.id,
            period: period,
            sheetType: sheetType
        )
    }
}
