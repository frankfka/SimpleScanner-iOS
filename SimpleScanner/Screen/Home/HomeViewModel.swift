//
// Created by Frank Jia on 2019-05-29.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewModel {

    // Realm is self-updating, so no need to retrieve from new state
    let documents: Results<PDF>

    init(state: HomeState, documents: Results<PDF>) {
        self.documents = documents
    }

}
