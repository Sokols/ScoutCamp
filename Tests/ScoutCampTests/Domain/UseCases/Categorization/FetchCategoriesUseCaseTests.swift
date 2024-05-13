//
//  FetchCategoriesUseCaseTests.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 13/05/2024.
//

import XCTest
@testable import ScoutCamp

final class FetchCategoriesUseCaseTests: XCTestCase {

    func testFetchCategoriesUseCase_whenSuccess_thenCategoriesAreReturned() async throws {
        // given
        let categoriesRepository = CategoriesRepositoryMock(isFailure: false)
        let useCase = DefaultFetchCategoriesUseCase(categoriesRepository: categoriesRepository)

        // when
        let result = await useCase.execute()
        let categories = try result.get().categories

        // then
        XCTAssertFalse(categories.isEmpty)
    }

    func testFetchCategoriesUseCase_whenSuccess_thenCategoriesAreUpdatedWithUrls() async throws {
        // given
        let categoriesRepository = CategoriesRepositoryMock(isFailure: false)
        let useCase = DefaultFetchCategoriesUseCase(categoriesRepository: categoriesRepository)

        // when
        let result = await useCase.execute()
        let categories = try result.get().categories

        // then
        let category = categories.first
        XCTAssertNotNil(category)
        XCTAssertNotNil(category?.url)
    }

    func testFetchCategoriesUseCase_whenFailure_thenErrorIsReturned() async throws {
        // given
        let categoriesRepository = CategoriesRepositoryMock(isFailure: true)
        let useCase = DefaultFetchCategoriesUseCase(categoriesRepository: categoriesRepository)

        // when
        let result = await useCase.execute()

        // then
        XCTAssertThrowsError(try result.get())
    }

}
