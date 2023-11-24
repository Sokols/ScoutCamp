//
//  AppTeamSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 23/11/2023.
//

import Foundation

struct AppTeamSheet: Hashable {
    let teamSheetId: String
    let sheetId: String

    let period: CategorizationPeriod
    let sheetType: SheetType
    let team: Team
    let category: Category
    let categoryUrl: URL?

    let points: Int
    let isDraft: Bool

    let createdAt: Date
    let updatedAt: Date
}

extension AppTeamSheet {
    static func from(
        teamSheet: TeamCategorizationSheet,
        sheet: CategorizationSheet?,
        team: Team
    ) -> AppTeamSheet {
        let period = CategorizationPeriodsService.categoryPeriodFor(id: sheet?.periodId)
        let sheetType = SheetTypesService.sheetTypeFor(id: sheet?.sheetTypeId)
        let category = CategoriesService.categoryFor(id: teamSheet.categoryId)
        let url = CategoriesService.urlFor(id: category?.id)

        return AppTeamSheet(
            teamSheetId: teamSheet.id,
            sheetId: teamSheet.categorizationSheetId,
            period: period!,
            sheetType: sheetType!,
            team: team,
            category: category!,
            categoryUrl: url,
            points: teamSheet.points,
            isDraft: teamSheet.isDraft,
            createdAt: teamSheet.createdAt,
            updatedAt: teamSheet.updatedAt
        )
    }
}
