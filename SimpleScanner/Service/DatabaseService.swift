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

    // Retrieves all documents from database
    func allDocuments() -> Results<PDF> {
        return database.objects(PDF.self)
    }

    // Adds a PDF file to database
    func addPDFToDatabase(_ file: PDFFile) -> Result<PDF, RealmError> {
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
                return .failure(RealmError(state: .realmWriteError, innerError: error))
            }
        } else {
            return .failure(RealmError(state: .invalidObject, innerError: nil))
        }
    }

    // Deletes a PDF file from database
    func deletePDFFromDatabase(_ pdf: PDF) -> Result<Void, RealmError> {
        do {
            try database.write {
                database.delete(pdf)
            }
            return .success(())
        } catch {
            return .failure(RealmError(state: .realmDeleteError, innerError: error))
        }
    }

}
