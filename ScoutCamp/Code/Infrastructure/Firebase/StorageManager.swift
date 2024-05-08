//
//  StorageManager.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 26/10/2023.
//

import Foundation
import FirebaseStorage

protocol StorageManager {
    func getImageUrls(from paths: [String]) async throws -> [String:URL]
}

final class DefaultStorageManager: ObservableObject, StorageManager {
    private let reference = Storage.storage().reference()

    func getImageUrls(from paths: [String]) async throws -> [String:URL] {
        try await withThrowingTaskGroup(of: (String, URL).self) { group in
            for path in paths {
                group.addTask {
                    return try await (path, self.reference.child(path).downloadURL())
                }
            }
            var dictionary: [String:URL] = [:]

            while let (index, object) = try await group.next() {
                dictionary[index] = object
            }

            return dictionary
        }
    }
}
