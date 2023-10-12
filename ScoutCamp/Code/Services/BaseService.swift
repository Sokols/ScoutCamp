//
//  BaseService.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirebaseCollection: String {
    case regiments
    case troops
    case teams
}

typealias FirebaseModel = Codable
typealias ResultArray<T: FirebaseModel> = ([T]?, Error?)
typealias ResultObject<T: FirebaseModel> = (T?, Error?)

class BaseService: NSObject {
    func fetch<T: FirebaseModel>(query: Query) async -> ResultArray<T> {
        do {
            let snapshot = try await query.getDocuments()
            let data = snapshot.documents.compactMap { (doc) -> T? in
                return try? doc.data(as: T.self)
            }
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }

    func getAll<T: FirebaseModel>(collection: FirebaseCollection) async -> ResultArray<T> {
        do {
            let snapshot = try await Firestore.firestore().collection(collection.rawValue).getDocuments()
            let data = snapshot.documents.compactMap { (doc) -> T? in
                return try? doc.data(as: T.self)
            }
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }

    // MARK: - Pagination

    func getUserItems<T: FirebaseModel>(
        collection: FirebaseCollection,
        orderBy: String,
        limit: Int? = nil,
        offset: Int? = nil
    ) async -> ResultArray<T> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return (nil, nil)
        }
        return await getItemsForUser(
            paramName: "userId",
            paramValue: uid,
            collection: collection,
            orderBy: orderBy,
            limit: limit,
            offset: offset
        )
    }

    func getItemsForUser<T: FirebaseModel>(
        paramName: String,
        paramValue: String,
        collection: FirebaseCollection,
        orderBy: String,
        limit: Int?,
        offset: Int?
    ) async -> ResultArray<T> {
        var query = Firestore.firestore()
            .collection(collection.rawValue)
            .whereField(paramName, isEqualTo: paramValue)
            .order(by: orderBy, descending: true)
        if let limit = limit {
            query = query.limit(to: limit)
        }
        if let offset = offset {
            query = query.start(at: [offset])
        }
        do {
            let snapshot = try await query.getDocuments()
            let data = snapshot.documents.compactMap { (doc) -> T? in
                return try? doc.data(as: T.self)
            }
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }
}
