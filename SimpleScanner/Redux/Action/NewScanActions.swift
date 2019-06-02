//
// Created by Frank Jia on 2019-05-31.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import ReSwift

// Add Page pressed
struct AddPagePressedAction: Action { }
// Scan was successful
struct AddPageScanSuccessAction: Action {
    let new: UIImage
}
// Add page process was successful
struct AddPageSuccessAction: Action, CustomStringConvertible {
    let new: TempFile
    var description: String {
        return "AddPageSuccessAction: \(new.url.absoluteString)"
    }
}
// Add Page returned error
struct AddPageErrorAction: Action, CustomStringConvertible {
    let error: Error?
    var description: String {
        if let error = error as? WriteTempPageError {
            return "AddPageErrorAction: State: \(error.state) | Message: \(error.innerError?.localizedDescription)"
        } else {
            return "AddPageErrorAction: \(error?.localizedDescription)"
        }
    }
}
// Page icon was tapped
struct PageIconTappedAction: Action, CustomStringConvertible {
    let index: Int
    var description: String {
        return "PageIconTappedAction: \(index)"
    }
}
// Save Pressed Action
struct SaveDocumentPressedAction: Action, CustomStringConvertible {
    let pages: [TempFile]
    let fileName: String
    var description: String {
        return "SaveDocumentPressedAction: Saving \(pages.count) pages to \(fileName).pdf"
    }
}
// Save Complete Action
struct SaveDocumentSuccessAction: Action {
    let pdf: PDFFile
}
// Save Error Action
struct SaveDocumentErrorAction: Action, CustomStringConvertible {
    let error: WritePDFError?
    var description: String {
        return "SaveDocumentErrorAction: State: \(error?.state) | Errored Pages: \(error?.erroredPages)"
    }
}
// User cancelled scan
struct CancelNewScanAction: Action { }
// Navigated away
struct NewScanNavigateAwayAction: Action { }