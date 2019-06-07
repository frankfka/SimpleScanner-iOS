//
// Created by Frank Jia on 2019-05-31.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

class NewScanState {

    let state: ActivityState
    let error: UserFriendlyError?
    let pages: [TempFile]
    let exportedPDF: PDF?

    // Navigation
    let showScanVC: Bool
    let showPageWithIndex: Int?
    let dismissNewScanVC: Bool

    init(
            pages: [TempFile] = [],
            state: ActivityState = .none,
            error: UserFriendlyError? = nil,
            showScanVC: Bool = false,
            showPageWithIndex: Int? = nil,
            dismissNewScanVC: Bool = false,
            exportedPDF: PDF? = nil
    ) {
        self.state = state
        self.error = error
        self.pages = pages
        self.showScanVC = showScanVC
        self.showPageWithIndex = showPageWithIndex
        self.dismissNewScanVC = dismissNewScanVC
        self.exportedPDF = exportedPDF
    }

    func reduce(action: Action, state: NewScanState) -> NewScanState {
        switch action {
        case _ as CancelNewScanAction:
            return NewScanState(dismissNewScanVC: true)
        case _ as ExportedPDFViewDismissedAction:
            return NewScanState(dismissNewScanVC: true)
        case _ as AddPagePressedAction:
            return NewScanState(pages: self.pages, showScanVC: true)
        case _ as AddPageScanSuccessAction:
            return NewScanState(pages: self.pages, state: .loading)
        case let action as AddPageSuccessAction:
            // Add arrays to create new array
            return NewScanState(pages: self.pages + [action.new])
        case _ as AddPageErrorAction:
            return NewScanState(pages: self.pages, state: .error, error: UserFriendlyError(displayStr: Text.WritePageErrorMsg))
        case _ as SaveDocumentPressedAction:
            return NewScanState(pages: self.pages, state: .loading)
        case let action as SaveDocumentSuccessAction:
            return NewScanState(exportedPDF: action.pdf)
        case _ as SaveDocumentErrorAction:
            return NewScanState(pages: self.pages, state: .error, error: UserFriendlyError(displayStr: Text.ExportPDFErrorMsg))
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
