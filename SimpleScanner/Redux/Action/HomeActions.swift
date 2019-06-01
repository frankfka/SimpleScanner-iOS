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
struct DocumentTappedAction: Action {
    let index: Int
}
