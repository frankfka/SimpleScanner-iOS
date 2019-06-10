//
// Created by Frank Jia on 2019-05-27.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation

class Text {

    // Home Page
    static let HomeViewTitle = "Documents"
    static let NewScanButton = "New Scan"
    static let PastScansHeader = "Past Scans"

    // New Scan Page
    static let NewScanTitle = "New Scan"
    static let AddPageButton = "Add Page"
    static let WritePageErrorMsg = "Page Scan Failed"
    static let ExportPDFErrorMsg = "PDF Export Failed"
    // New Scan Cell
    static func PageCellNumberLabel(currentPage: Int, totalPages: Int) -> String {
        return "\(currentPage) of \(totalPages)"
    }
    // Page Actions Dialog
    static let PageActionsDelete = "Delete"
    static let PageActionsView = "View"
    // Save Dialog
    static let SavePDFTitle = "Save PDF"
    static let SavePDFDescription = "Please specify a file name"
    static let SavePDFConfirm = "Confirm"
    static let SavePDFCancel = "Cancel"

    // SimplePDFView
    static let PDFViewError = "Something went wrong. Please try again"


}
