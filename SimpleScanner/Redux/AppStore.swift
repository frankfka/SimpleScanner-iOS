//
// Created by Frank Jia on 2019-05-26.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

public typealias AppStore = Store<AppState>
// Main store for the application state
public let appStore = AppStore(reducer: appReducer, state: nil, middleware: allMiddleware)

// Primary reducer for the application
func appReducer(action: Action, state: AppState?) -> AppState {
    // Default state if state does not exist
    let state = state ?? AppState(
            homeState: HomeState(),
            newScanState: NewScanState()
    )
    return state.reduce(action: action, state: state)
}

private let allMiddleware: [Middleware<AppState>] = [
    loggerMiddleware,
    createPageMiddleware,
    exportPDFMiddleware
]