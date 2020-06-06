//
// Created by Frank Jia on 2019-05-31.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift
import PDFKit

class NewScanState {

    let state: ActivityState
    let error: UserFriendlyError?
    let pages: [PDFPage]
    let exportedPDF: PDF?

    // Navigation
    let showScanVC: Bool
    let showPageActionsWithIndex: Int?
    let showPageWithIndex: Int?
    let dismissNewScanVC: Bool

    init(
        pages: [PDFPage] = [],
        state: ActivityState = .none,
        error: UserFriendlyError? = nil,
        showScanVC: Bool = false,
        showPageActionsWithIndex: Int? = nil,
        showPageWithIndex: Int? = nil,
        dismissNewScanVC: Bool = false,
        exportedPDF: PDF? = nil
    ) {
        self.state = state
        self.error = error
        self.pages = pages
        self.showScanVC = showScanVC
        self.showPageActionsWithIndex = showPageActionsWithIndex
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
            return NewScanState(pages: self.pages, state: .loading, showScanVC: true)
        case _ as AddPageScanSuccessAction:
            return NewScanState(pages: self.pages, state: .loading)
        case let action as AddPageSuccessAction:
            // Add arrays to create new array
            return NewScanState(pages: self.pages + [action.new])
        case _ as AddPageErrorAction:
            return NewScanState(pages: self.pages, state: .error, error: UserFriendlyError(displayStr: TextConstants.WritePageErrorMsg))
        case let action as SwitchPageAction:
            return switchPage(action, state)
        case let action as PageIconTappedAction:
            return NewScanState(pages: self.pages, showPageActionsWithIndex: action.index)
        case let action as PresentPageAction:
            return NewScanState(pages: self.pages, state: .loading, showPageWithIndex: action.index)
        case let action as DeletePageAction:
            return deletePage(action, state)
        case _ as SaveDocumentPressedAction:
            return NewScanState(pages: self.pages, state: .loading)
        case let action as SaveDocumentSuccessAction:
            return NewScanState(exportedPDF: action.pdf)
        case _ as SaveDocumentErrorAction:
            return NewScanState(pages: self.pages, state: .error, error: UserFriendlyError(displayStr: TextConstants.ExportPDFErrorMsg))
        case _ as NewScanNavigateAwayAction:
            return didNavigateAway(action, state)
        default:
            return self
        }
    }

    // Reset all navigation states, but still preserve the scanned pages
    private func didNavigateAway(_: Action, _ state: NewScanState) -> NewScanState {
        return NewScanState(pages: state.pages)
    }

    // Switch ordering of the pages
    private func switchPage(_ action: SwitchPageAction, _ state: NewScanState) -> NewScanState {
        var newPages = state.pages
        let pageToMove = state.pages[action.originalIndex]
        newPages.remove(at: action.originalIndex)
        newPages.insert(pageToMove, at: action.destinationIndex)
        return NewScanState(pages: newPages)
    }

    // Delete page from state
    private func deletePage(_ action: DeletePageAction, _ state: NewScanState) -> NewScanState {
        var newPages = state.pages
        newPages.remove(at: action.index)
        return NewScanState(pages: newPages)
    }

}
