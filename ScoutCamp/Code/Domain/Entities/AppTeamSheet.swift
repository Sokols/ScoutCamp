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

extension AppTeamSheet {
    var doesAlreadyExist: Bool { teamSheetId != nil }
}

extension AppTeamSheet {
    static func from(
        sheet: CategorizationSheet,
        team: Team
    ) -> AppTeamSheet? {
        guard let category = CategoriesService.getFirstCategory() else { return nil }

        return AppTeamSheet(
            teamSheetId: nil,
            sheet: sheet,
            team: team,
            category: category,
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        )
    }

    static func from(
        teamSheet: TeamCategorizationSheetDTO,
        sheet: CategorizationSheet,
        team: Team
    ) -> AppTeamSheet? {
        guard let category = CategoriesService.categoryFor(id: teamSheet.categoryId) else { return nil }

        return AppTeamSheet(
            teamSheetId: teamSheet.id,
            sheet: sheet,
            team: team,
            category: category,
            points: teamSheet.points,
            isDraft: teamSheet.isDraft,
            createdAt: teamSheet.createdAt,
            updatedAt: teamSheet.updatedAt
        )
    }
}

extension AppTeamSheet {
    func toTeamSheetData() -> [String: Any] {
        var map: [String: Any] = [
            "categorizationSheetId": sheet.sheetId,
            "teamId": team.id,
            "categoryId": category.id,
            "points": points,
            "isDraft": isDraft,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]

        if let teamSheetId {
            map["id"] = teamSheetId
        }

        return map
    }
}
