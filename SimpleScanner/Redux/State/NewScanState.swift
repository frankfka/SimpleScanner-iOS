//
// Created by Frank Jia on 2019-05-31.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

class NewScanState {

    let state: ActivityState
    let pages: [UIImage]

    // Navigation
    let showScanVC: Bool
    let showPageWithIndex: Int?
    let dismissNewScanVC: Bool

    init(
            pages: [UIImage] = [],
            state: ActivityState = .none,
            showScanVC: Bool = false,
            showPageWithIndex: Int? = nil,
            dismissNewScanVC: Bool = false
    ) {
        self.state = state
        self.pages = pages
        self.showScanVC = showScanVC
        self.showPageWithIndex = showPageWithIndex
        self.dismissNewScanVC = dismissNewScanVC
    }

    func reduce(action: Action, state: NewScanState) -> NewScanState {
        switch action {
        case _ as CancelNewScanAction:
            return NewScanState(dismissNewScanVC: true)
        case _ as AddPagePressedAction:
            return NewScanState(pages: self.pages, showScanVC: true)
        case let action as AddPageSuccessAction:
            // Add arrays to create new array
            return NewScanState(pages: self.pages + [action.new])
        case let _ as AddPageErrorAction:
            return NewScanState(pages: self.pages, state: .error)
        case _ as SaveDocumentPressedAction:
            return self // TODO
        case _ as SaveDocumentSuccessAction:
            return self // TODO
        case _ as SaveDocumentErrorAction:
            return self // TODO
        case _ as NewScanNavigateAwayAction:
            return didNavigateAway(action, state)
        default:
            return self
        }
    }

    // Reset all navigation states, but still preserve the scanned pages
    private func didNavigateAway(_: Action, _ state: NewScanState) -> NewScanState {
        return NewScanState(pages: state.pages, showScanVC: false, showPageWithIndex: nil, dismissNewScanVC: false)
    }

}
