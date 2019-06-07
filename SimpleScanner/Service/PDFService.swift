//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import PDFKit

enum PageScaleSize {
    case none
    case A4
}

let A4Size: CGRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dp

class PDFService {

    static let shared = PDFService()

    // Creates a file name based on time
    static func getDefaultFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMMdd_HH-mm_ss"
        let dateString = dateFormatter.string(from: Date())
        return "SimpleScanner_\(dateString)"
    }

    // Saves a page to disk and returns URL
    func createPage(_ image: UIImage, scaleTo: PageScaleSize = .A4) -> (PDFPage?, Error?) {
        if let page = PDFPage(image: image) {
            page.setBounds(bounds(for: image, with: scaleTo), for: .mediaBox)
            return (page, nil)
        } else {
            return (nil, WritePageError(state: .conversionError))
        }
    }

    // Generates a PDF from scanned images
    func savePDF(from pages: [PDFPage], fileName: String) -> (PDFFile?, WritePDFError?) {
        // Prevent writing of empty documents
        guard !pages.isEmpty else {
            return (nil, WritePDFError(state: .noPages))
        }
        let document = PDFDocument()
        pages.forEach { page in
            document.insert(page, at: document.pageCount)
        }
        let documentFile = PDFFile(fileName: fileName)
        if document.write(to: documentFile.url) {
            return (documentFile, nil)
        } else {
            return (nil, WritePDFError(state: .writeError))
        }
    }

    // Retrieves a PDF with a given name
    func getPDF(fileName: String) -> PDFDocument? {
        let fileUrl = getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("pdf")
        return PDFDocument(url: fileUrl)
    }

    // Calculates bounds such that entire page will fit
    private func bounds(for page: UIImage, with scale: PageScaleSize) -> CGRect {
        switch scale {
        case .A4:
            let scale = A4Size.width / page.size.width
            return CGRect(x: 0, y: 0, width: scale * page.size.width, height: scale * page.size.height)
        default:
            return CGRect(x: 0, y: 0, width: page.size.width, height: page.size.height)
        }
    }

}
