//
// Created by Frank Jia on 2019-06-04.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import RealmSwift

class PDF: Object {
    @objc dynamic var fileName: String = ""
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var path: String = ""
}

extension PDF {

    // Returns true if PDF is valid
    static func verify(_ pdf: PDF) -> Bool {
        if !pdf.fileName.isEmpty && !pdf.path.isEmpty {
            return true
        }
        return false
    }

}
