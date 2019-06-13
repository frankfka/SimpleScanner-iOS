//
// Created by Frank Jia on 2019-05-30.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

// Add document tapped on home screen
struct AddNewDocumentTappedAction: Action { }
// Called when anything is presented/pushed onto Home screen
struct HomeNavigateAwayAction: Action { }
// When document tapped in UICollectionView
struct ShowDocumentTappedAction: Action {
    let index: Int
}
// When document options tapped
struct ShowDocumentOptionsTappedAction: Action {
    let index: Int
}
// When user wants to delete document
struct DeleteDocumentAction: Action {
    let index: Int
}
struct DeleteDocumentOkAction: Action { }
