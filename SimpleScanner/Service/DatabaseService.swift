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

    func addPDF(_ file: PDFFile) {
        var newPDF = PDF()
        newPDF.fileName = file.name
        newPDF.path = file.url.path
        newPDF.dateCreated = Date()
        if PDF.verify(newPDF) {
            try! database.write {
                database.add(newPDF)
            }
        } else {
            // TODO: Deal with errors including in try!
        }
    }

    func deletePDF() {
        // TODO
    }

}
