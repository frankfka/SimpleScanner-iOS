//
// Created by Frank Jia on 2019-05-26.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift
import RealmSwift

public struct AppState: StateType {

    let homeState: HomeState
    let newScanState: NewScanState
    let documentState: DocumentState

    func reduce(action: Action, state: AppState) -> AppState {
        return AppState(
            homeState: homeState.reduce(action: action, state: state.homeState),
            newScanState: newScanState.reduce(action: action, state: state.newScanState),
            documentState: documentState // Realm is self-updating, no reducer required
        )
    }
}

struct DocumentState {
    let all: Results<PDF>
}