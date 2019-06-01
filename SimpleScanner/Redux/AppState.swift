//
// Created by Frank Jia on 2019-05-26.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

public struct AppState: StateType {

    let homeState: HomeState
    let newScanState: NewScanState

    func reduce(action: Action, state: AppState) -> AppState {
        return AppState(
                homeState: homeState.reduce(action: action, state: state.homeState),
                newScanState: newScanState.reduce(action: action, state: state.newScanState)
        )
    }
}