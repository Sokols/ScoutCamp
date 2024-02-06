//
//  TeamSheet+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension TeamSheet {
    static func from(
        sheet: CategorizationSheet,
        team: Team
    ) -> TeamSheet? {
        guard let category = CategoriesService.getFirstCategory() else { return nil }

        return TeamSheet(
            teamSheetId: nil,
            sheet: sheet,
            team: team,
            category: category.toDomain(),
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        )
    }

    static func from(
        teamSheet: TeamSheetDTO,
        sheet: CategorizationSheet,
        team: Team
    ) -> TeamSheet? {
        guard let category = CategoriesService.categoryFor(id: teamSheet.categoryId) else { return nil }

        return TeamSheet(
            teamSheetId: teamSheet.id,
            sheet: sheet,
            team: team,
            category: category.toDomain(),
            points: teamSheet.points,
            isDraft: teamSheet.isDraft,
            createdAt: teamSheet.createdAt,
            updatedAt: teamSheet.updatedAt
        )
    }
}

extension TeamSheet {
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
