//
//  SheetTypesService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 20/10/2023.
//

import Foundation

protocol SheetTypesServiceProtocol {
    func getSheetTypes() async -> ResultArray<SheetTypeDTO>
}

final class SheetTypesService: BaseService, SheetTypesServiceProtocol {
    private(set) static var sheetTypes: [SheetTypeDTO] = []

    static func sheetTypeFor(id: String?) -> SheetTypeDTO? {
        return SheetTypesService.sheetTypes.first { $0.id == id }
    }

    func getSheetTypes() async -> ResultArray<SheetTypeDTO> {
        let result: ResultArray<SheetTypeDTO> = await getAll(collection: .sheetTypes)
        SheetTypesService.sheetTypes.removeAll()
        result.0?.forEach { sheetType in
            SheetTypesService.sheetTypes.append(sheetType)
        }
        return result
    }
}
