//
//  TestData.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/11/2023.
//

import Foundation

struct TestData {

    // MARK: - Models

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
        category: nil,
        mainAssignmentGroup: TestData.assignmentGroup,
        assignmentType: .numeric,
        assignmentGroups: [TestData.assignmentGroup: 1.0],
        description: "Test description",
        maxPoints: 5,
        maxScoringValue: nil,
        minimums: nil
    )

    static let booleanAppAssignment = AppAssignment(
        assignmentId: "",
        category: nil,
        mainAssignmentGroup: TestData.assignmentGroup,
        assignmentType: .boolean,
        assignmentGroups: [TestData.assignmentGroup: 1.0],
        description: "Test description",
        maxPoints: 5,
        maxScoringValue: nil,
        minimums: nil
    )

    // MARK: - Junctions

    static let teamAsssignmentJunction = TeamAssignmentJunction(
        assignment: assignment
    )

    static let categorizationSheetJunction = CategorizationSheetJunction(
        categorizationSheet: categorizationSheet,
        team: team,
        teamCategorizationSheet: teamCategorizationSheet
    )

    // MARK: - Lists

    static let categorizationSheetJunctions = [
        categorizationSheetJunction,
        categorizationSheetJunction
    ]
}
