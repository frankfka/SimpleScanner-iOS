//
// Created by Frank Jia on 2019-05-29.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit

class HomeViewModel {

    let documents: [String]

    init(state: HomeState) {
        self.documents = state.documents
    }

}
