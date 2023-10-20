//
//  SheetTypesService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

protocol SheetTypesServiceProtocol {
    func getSheetTypes() async -> ResultArray<SheetType>
}

class SheetTypesService: BaseService, SheetTypesServiceProtocol {
    func getSheetTypes() async -> ResultArray<SheetType> {
        await getAll(collection: .sheetTypes)
    }
}
