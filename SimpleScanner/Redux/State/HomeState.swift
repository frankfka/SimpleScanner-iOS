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
    let showDocumentOptionsWithIndex: Int?

    init(
        state: ActivityState = .none,
        showAddDocument: Bool = false,
        showDocumentWithIndex: Int? = nil,
        showDocumentOptionsWithIndex: Int? = nil
    ) {
        self.state = state
        self.showAddDocument = showAddDocument
        self.showDocumentWithIndex = showDocumentWithIndex
        self.showDocumentOptionsWithIndex = showDocumentOptionsWithIndex
    }

    func reduce(action: Action, state: HomeState) -> HomeState {
        switch action {
        case _ as AddNewDocumentTappedAction:
            return HomeState(showAddDocument: true)
        case let action as ShowDocumentTappedAction:
            return HomeState(showDocumentWithIndex: action.index)
        case let action as ShowDocumentOptionsTappedAction:
            return HomeState(showDocumentOptionsWithIndex: action.index)
        case _ as DeleteDocumentAction:
            return HomeState(state: .loading)
        case _ as DeleteDocumentSuccessAction:
            return reset()
        case _ as DeleteDocumentErrorAction:
            return HomeState(state: .error)
        case _ as HomeNavigateAwayAction:
            return reset()
        default:
            return self
        }
    }

    // Reset all navigation states
    private func reset() -> HomeState {
        return HomeState(state: .none, showAddDocument: false, showDocumentWithIndex: nil, showDocumentOptionsWithIndex: nil)
    }

}
