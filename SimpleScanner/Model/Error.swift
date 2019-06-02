//
// Created by Frank Jia on 2019-06-02.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation

struct WriteTempPageError: Error {
    let state: WriteTempPageErrorState
    let innerError: Error?

    enum WriteTempPageErrorState {
        case pngDataConversionError
        case writeError
    }
}
struct WritePDFError: Error {
    let erroredPages: [Int] // Zero based index
    let state: WritePDFErrorState

    enum WritePDFErrorState {
        case missingPages
        case noPages
        case writeError
    }
}