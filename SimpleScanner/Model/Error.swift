//
// Created by Frank Jia on 2019-06-02.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation

struct WritePageError: Error {
    let state: WriteTempPageErrorState

    enum WriteTempPageErrorState {
        case conversionError
    }
}

struct WritePDFError: Error {
    let state: WritePDFErrorState

    enum WritePDFErrorState {
        case noPages
        case writeError
    }
}

struct RealmError: Error {
    let state: RealmErrorState
    let innerError: Error?

    enum RealmErrorState {
        case invalidObject
        case realmError
    }
}

// Can be shown in UI
struct UserFriendlyError: Error {
    let displayStr: String
}