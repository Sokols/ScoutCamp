//
//  StorageManager.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/10/2023.
//

import Foundation
import FirebaseStorage

protocol StorageManagerProtocol {
    func getImageRef(path: String) async throws -> URL
}

class StorageManager: ObservableObject, StorageManagerProtocol {
    private let reference = Storage.storage().reference()

    func getImageRef(path: String) async throws -> URL {
        return try await reference.child(path).downloadURL()
    }
}
