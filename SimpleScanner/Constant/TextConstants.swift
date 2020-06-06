//
// Created by Frank Jia on 2019-05-27.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation

class TextConstants {

    // General
    static let Confirm = "Confirm"
    static let Cancel = "Cancel"
    static let Delete = "Delete"

    // Home Page
    static let HomeViewTitle = "Documents"
    static let NewScanButton = "New Scan"
    static let PastScansHeader = "Past Scans"
    static func NumPages(numPages: Int) -> String {
        return "\(numPages) Pages"
    }
    static func DateString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        return dateFormatter.string(from: date)
    }

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
    static let PageActionsView = "View"
    // Save Dialog
    static let SavePDFTitle = "Save PDF"
    static let SavePDFDescription = "Please specify a file name"

    // SimplePDFView
    static let PDFViewError = "Something went wrong. Please try again"


}
