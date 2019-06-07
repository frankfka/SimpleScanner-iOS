//
// Created by Frank Jia on 2019-06-04.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseService {

    // TODO DI
    static let shared = DatabaseService(database: try! Realm())

    private let database: Realm

    init(database: Realm) {
        self.database = database
    }

    func allDocuments() -> Results<PDF> {
        return database.objects(PDF.self)
    }

    func addPDF(_ file: PDFFile) -> (PDF?, RealmError?) {
        let newPDF = PDF()
        newPDF.fileName = file.name
        newPDF.dateCreated = Date()
        if PDF.verify(newPDF) {
            do {
                try database.write {
                    database.add(newPDF)
                }
                return (newPDF, nil)
            } catch {
                return (nil, RealmError(state: .realmError, innerError: error))
            }
        } else {
            return (nil, RealmError(state: .invalidObject, innerError: nil))
        }
    }

    func deletePDF() {
        // TODO
    }

}
