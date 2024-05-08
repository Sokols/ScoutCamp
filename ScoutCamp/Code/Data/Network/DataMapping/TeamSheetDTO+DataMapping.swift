//
//  TeamSheet+DataMapping.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 06/02/2024.
//

import Foundation

extension TeamSheetDTO {
    static func from(
        sheet: CategorizationSheet,
        team: Team
    ) -> TeamSheet {
        return TeamSheet(
            teamSheetId: nil,
            sheet: sheet,
            team: team,
            category: nil,
            points: 0,
            isDraft: true,
            createdAt: .now,
            updatedAt: .now
        )
    }

    func toDomain(
        sheet: CategorizationSheet,
        team: Team,
        category: Category
    ) -> TeamSheet {
        return TeamSheet(
            teamSheetId: self.id,
            sheet: sheet,
            team: team,
            category: category,
            points: self.points,
            isDraft: self.isDraft,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
}

extension TeamSheet {
    func toTeamSheetData() -> [String: Any] {
        var map: [String: Any] = [
            "categorizationSheetId": sheet.sheetId,
            "teamId": team.id,
            "points": points,
            "isDraft": isDraft,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]

        if let teamSheetId {
            map["id"] = teamSheetId
        }

        if let category {
            map["categoryId"] = category.id
        }

        return map
    }
}
