//
// Created by Frank Jia on 2019-05-30.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import ReSwift

struct HomeState {

    // Navigation
    let showAddDocument: Bool
    let showDocumentWithIndex: Int?

    init(
            showAddDocument: Bool = false,
            showDocumentWithIndex: Int? = nil
    ) {
        self.showAddDocument = showAddDocument
        self.showDocumentWithIndex = showDocumentWithIndex
    }

    func reduce(action: Action, state: HomeState) -> HomeState {
        switch action {
        case _ as AddNewDocumentTappedAction:
            return HomeState(showAddDocument: true)
        case let action as DocumentTappedAction:
            return HomeState(showDocumentWithIndex: action.index)
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
