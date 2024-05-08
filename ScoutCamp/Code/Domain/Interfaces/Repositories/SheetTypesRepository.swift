//
//  SheetTypesRepository.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import Foundation

protocol SheetTypesRepository {
    func fetchSheetTypes() async -> Result<[SheetType], Error>
}

