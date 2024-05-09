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

    static let firstCategory = Category(
        id: "testId",
        name: "Polowa",
        imagePath: "path",
        order: 1
    )

    static let secondCategory = Category(
        id: "testId",
        name: "Leśna",
        imagePath: "path",
        order: 2
    )

    static let team = Team(
        id: "team_id",
        userId: "user_id",
        troopId: "troop_id",
        regimentId: "regiment_id",
        name: "name"
    )

    static let troop = Team(
        id: "troop_id",
        userId: nil,
        troopId: nil,
        regimentId: "regiment_id",
        name: "name"
    )

    static let regiment = Team(
        id: "regiment_id",
        userId: nil,
        troopId: nil,
        regimentId: nil,
        name: "name"
    )

    static let assignment = AssignmentDTO(
        id: "",
        mainAssignmentGroupId: "",
        dependentOnAssignmentId: nil,
        assignmentType: "numeric",
        description: "TEST DESCRIPTION",
        maxPoints: 5,
        maxScoringValue: nil
    )

    static let assignmentGroup = AssignmentGroup(
        id: "testId",
        name: "AssignmentGroup",
        order: 0
    )

    static let secondAssignmentGroup = AssignmentGroup(
        id: "testId2",
        name: "Second AssignmentGroup",
        order: 1
    )

    static let categorizationSheetDTO = CategorizationSheetDTO(
        id: "",
        periodId: "",
        sheetTypeId: ""
    )

    static let teamCategorizationSheet = TeamSheetDTO(
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
        mainAssignmentGroup: TestData.assignmentGroup,
        assignmentType: .numeric,
        assignmentGroupShares: TestData.assignmentGroupShares,
        description: "Test description",
        maxPoints: 5,
        value: 15,
        maxScoringValue: 20
    )

    static let booleanAppAssignment = AppAssignment(
        assignmentId: "",
        teamAssignmentId: nil,
        mainAssignmentGroup: TestData.assignmentGroup,
        assignmentType: .boolean,
        assignmentGroupShares: [],
        description: "Test description",
        maxPoints: 5,
        maxScoringValue: nil
    )

    static let categorizationSheet = CategorizationSheet(
        sheetId: "testId",
        period: TestData.period,
        sheetType: TestData.sheetType
    )

    static let appTeamSheet = TeamSheet(
        teamSheetId: "testId",
        sheet: TestData.categorizationSheet,
        team: TestData.team,
        category: TestData.firstCategory,
        points: 10,
        isDraft: true,
        createdAt: .now,
        updatedAt: .now
    )

    static let firstAssignmentGroupMinimum = AssignmentGroupCategoryMinimum(
        groupMinimumId: "testId",
        assignmentGroupId: TestData.assignmentGroup.id,
        category: TestData.firstCategory,
        minimumPoints: 5
    )

    static let secondAssignmentGroupMinimum = AssignmentGroupCategoryMinimum(
        groupMinimumId: "testId",
        assignmentGroupId: TestData.assignmentGroup.id,
        category: TestData.secondCategory,
        minimumPoints: 10
    )

    static let assignmentGroupSection = AssignmentGroupSection(
        group: TestData.assignmentGroup,
        groupMinimums: [TestData.firstAssignmentGroupMinimum, TestData.secondAssignmentGroupMinimum],
        assignments: [TestData.booleanAppAssignment, TestData.numericAppAssignment],
        partialAssignments: []
    )

    static let assignmentGroupShares = [
        AppAssignment.AssignmentGroupShare(
            assignmentGroup: TestData.assignmentGroup,
            percentageShare: 0.2
        ),
        AppAssignment.AssignmentGroupShare(
            assignmentGroup: TestData.secondAssignmentGroup,
            percentageShare: 0.8
        )
    ]
}
