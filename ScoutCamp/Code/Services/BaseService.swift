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
    case assignmentGroupAssignmentJunctions
    case assignmentGroups
    case assignments
    case categories
    case categorizationPeriods
    case categorizationSheets
    case regiments
    case sheetTypes
    case teamCategorizationSheetAssignments
    case teamCategorizationSheets
    case teams
    case troops
    case users
}

typealias FirebaseModel = Codable
typealias ResultArray<T: FirebaseModel> = ([T]?, Error?)
typealias ResultObject<T: FirebaseModel> = (T?, Error?)

class BaseService: ObservableObject {
    func fetch<T: FirebaseModel>(query: Query) async -> ResultArray<T> {
        do {
            let snapshot = try await query.getDocuments()
            let data = try snapshot.documents.compactMap { (doc) -> T? in
                return try doc.data(as: T.self)
            }
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }

    func getAll<T: FirebaseModel>(collection: FirebaseCollection) async -> ResultArray<T> {
        do {
            let snapshot = try await Firestore.firestore().collection(collection.rawValue).getDocuments()
            let data = try snapshot.documents.compactMap { (doc) -> T? in
                return try doc.data(as: T.self)
            }
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }

    func createData(data: [String: Any], collection: FirebaseCollection) async -> Error? {
        do {
            let collection = Firestore.firestore().collection(collection.rawValue)
            let doc = collection.document()
            var newData = data
            newData["id"] = doc.documentID
            try await doc.setData(newData)
            return nil
        } catch {
            return error
        }
    }

    func updateData(id: String, data: [String: Any], collection: FirebaseCollection) async -> Error? {
        do {
            let collection = Firestore.firestore().collection(collection.rawValue)
            let doc = collection.document(id)
            try await doc.setData(data)
            return nil
        } catch {
            return error
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
            let data = try snapshot.documents.compactMap { (doc) -> T? in
                return try doc.data(as: T.self)
            }
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }
}
