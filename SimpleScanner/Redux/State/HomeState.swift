//
// Created by Frank Jia on 2019-05-30.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import ReSwift

struct HomeState {

    let state: ActivityState
    // Navigation
    let showAddDocument: Bool
    let showDocumentWithIndex: Int?

    init(
            state: ActivityState = .none,
            showAddDocument: Bool = false,
            showDocumentWithIndex: Int? = nil
    ) {
        self.state = state
        self.showAddDocument = showAddDocument
        self.showDocumentWithIndex = showDocumentWithIndex
    }

    func reduce(action: Action, state: HomeState) -> HomeState {
        switch action {
        case _ as AddNewDocumentTappedAction:
            return HomeState(state: .loading, showAddDocument: true)
        case let action as DocumentTappedAction:
            return HomeState(state: .loading, showDocumentWithIndex: action.index)
        case _ as HomeNavigateAwayAction:
            return didNavigateAway()
        default:
            return self
        }
    }

    // Reset all navigation states
    private func didNavigateAway() -> HomeState {
        return HomeState(showAddDocument: false, showDocumentWithIndex: nil)
    }

}
