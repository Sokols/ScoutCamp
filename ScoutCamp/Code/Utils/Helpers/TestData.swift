//
//  TestData.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/11/2023.
//

import Foundation

struct TestData {

    // MARK: - Models

    static let period = CategorizationPeriod(
        id: "testId",
        name: "2023-2024"
    )

    static let sheetType = SheetType(
        id: "testId",
        name: "obozowe",
        order: 2
    )

    static let category = Category(
        id: "testId",
        name: "Polowa",
        imagePath: "path",
        order: 1
    )

    static let team = Team(
        id: "",
        userId: "",
        troopId: "",
        regimentId: "",
        name: ""
    )

    static let assignment = Assignment(
        id: "",
        categoryId: "",
        mainAssignmentGroupId: "",
        categorizationSheetId: "",
        assignmentType: "numeric",
        description: "TEST DESCRIPTION",
        maxPoints: 5,
        maxScoringValue: nil,
        minimums: nil
    )

    static let assignmentGroup = AssignmentGroup(
        id: "testId", 
        name: "AssignmentGroup",
        order: 0
    )

    static let categorizationSheet = CategorizationSheet(
        id: "",
        periodId: "",
        sheetTypeId: ""
    )

    static let teamCategorizationSheet = TeamCategorizationSheet(
        id: "1",
        categorizationSheetId: "1",
        teamId: "1",
        categoryId: "1",
        points: 1,
        isDraft: true,
        createdAt: Date(),
        updatedAt: Date()
    )

    // MARK: - App models

    static let numericAppAssignment = AppAssignment(
        assignmentId: "",
        teamAssignmentId: nil,
        category: nil,
        mainAssignmentGroup: TestData.assignmentGroup,
        assignmentType: .numeric,
        assignmentGroups: [TestData.assignmentGroup: 1.0],
        description: "Test description",
        maxPoints: 5,
        minimums: nil,
        maxScoringValue: nil
    )

    static let booleanAppAssignment = AppAssignment(
        assignmentId: "",
        teamAssignmentId: nil,
        category: nil,
        mainAssignmentGroup: TestData.assignmentGroup,
        assignmentType: .boolean,
        assignmentGroups: [TestData.assignmentGroup: 1.0],
        description: "Test description",
        maxPoints: 5,
        minimums: nil,
        maxScoringValue: nil
    )

    static let appSheet = AppSheet(
        sheetId: "testId",
        period: TestData.period,
        sheetType: TestData.sheetType
    )

    static let appTeamSheet = AppTeamSheet(
        teamSheetId: "testId",
        sheet: TestData.appSheet,
        team: TestData.team,
        category: TestData.category,
        categoryUrl: nil,
        points: 10,
        isDraft: true,
        createdAt: .now,
        updatedAt: .now
    )
}
