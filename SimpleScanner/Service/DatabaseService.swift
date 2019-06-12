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

    func addPDF(_ file: PDFFile) -> Result<PDF, RealmError> {
        let newPDF = PDF()
        newPDF.fileName = file.name
        newPDF.dateCreated = Date()
        if PDF.verify(newPDF) {
            do {
                try database.write {
                    database.add(newPDF)
                }
                return .success(newPDF)
            } catch {
                return .failure(RealmError(state: .realmError, innerError: error))
            }
        } else {
            return .failure(RealmError(state: .invalidObject, innerError: nil))
        }
    }

    func deletePDF(_ pdf: PDF) -> Result<Void, Error> {
        do {
            try database.write {
                database.delete(pdf)
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }

}
