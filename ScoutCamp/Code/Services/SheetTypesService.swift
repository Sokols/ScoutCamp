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

final class SheetTypesService: BaseService, SheetTypesServiceProtocol {
    private(set) static var sheetTypes: [SheetType] = []

    static func sheetTypeFor(id: String?) -> SheetType? {
        return SheetTypesService.sheetTypes.first { $0.id == id }
    }

    func getSheetTypes() async -> ResultArray<SheetType> {
        let result: ResultArray<SheetType> = await getAll(collection: .sheetTypes)
        result.0?.forEach { sheetType in
            SheetTypesService.sheetTypes.append(sheetType)
        }
        return result
    }
}
