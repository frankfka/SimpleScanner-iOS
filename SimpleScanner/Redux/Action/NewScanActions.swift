//
// Created by Frank Jia on 2019-05-31.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import ReSwift

// Add Page pressed
struct AddPagePressedAction: Action { }
// Add Page returned OK
struct AddPageSuccessAction: Action {
    // Not ideal to pass around UIImage, but it doesn't make sense to save transient images to pass state as URL
    let new: UIImage
}
// Add Page returned error
struct AddPageErrorAction: Action, CustomStringConvertible {
    let error: Error
    var description: String {
        return "AddPageErrorAction: \(error.localizedDescription)"
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
struct SaveDocumentPressedAction: Action { }
// Save Complete Action
struct SaveDocumentSuccessAction: Action { }
// Save Error Action
struct SaveDocumentErrorAction: Action { }
// User cancelled scan
struct CancelNewScanAction: Action { }
// Navigated away
struct NewScanNavigateAwayAction: Action { }