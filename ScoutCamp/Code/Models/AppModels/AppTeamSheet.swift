//
//  AppTeamSheet.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 23/11/2023.
//

import Foundation

struct AppTeamSheet: Hashable {
    let teamSheetId: String?    // nil means team sheet is not yet saved

    let sheet: AppSheet

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
        sheet: AppSheet,
        team: Team
    ) -> AppTeamSheet {
        let category = CategoriesService.getFirstCategory()
        let url = CategoriesService.urlFor(id: category?.id)

        return AppTeamSheet(
            teamSheetId: nil,
            sheet: sheet,
            team: team,
            category: category!,
            categoryUrl: url,
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        )
    }

    static func from(
        teamSheet: TeamCategorizationSheet,
        sheet: AppSheet,
        team: Team
    ) -> AppTeamSheet {
        let category = CategoriesService.categoryFor(id: teamSheet.categoryId)
        let url = CategoriesService.urlFor(id: category?.id)

        return AppTeamSheet(
            teamSheetId: teamSheet.id,
            sheet: sheet,
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
