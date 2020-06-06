//
// Created by Frank Jia on 2019-06-02.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation

// Errors when dealing with PDFKit
struct PDFError: LocalizedError {
    let state: PDFErrorState
    let innerError: Error?

    init(state: PDFErrorState, innerError: Error? = nil) {
        self.state = state
        self.innerError = innerError
    }
    
    enum PDFErrorState {
        case pageConversionError
        case writeError
        case deleteError
    }

    public var errorDescription: String? {
        if let fileManagerError = self.innerError as? FileManagerError {
            return "\(self.state): \(fileManagerError.state) | \(fileManagerError.innerError?.localizedDescription ?? "")"
        } else if let realmError = self.innerError as? RealmError {
            return "\(self.state): \(realmError.state) | \(realmError.innerError?.localizedDescription ?? "")"
        } else {
            return "\(self.state): \(self.innerError?.localizedDescription ?? "")"
        }
    }
}

// Errors when dealing with disk
struct FileManagerError: Error {
    let state: FileManagerErrorState
    let innerError: Error?

    enum FileManagerErrorState {
        case noPages
        case writeError
        case deleteError
    }
}

// Errors when dealing with Realm
struct RealmError: Error {
    let state: RealmErrorState
    let innerError: Error?

    enum RealmErrorState {
        case invalidObject
        case realmWriteError
        case realmDeleteError
    }
}

// Can be shown in UI
struct UserFriendlyError: Error {
    let displayStr: String
}
