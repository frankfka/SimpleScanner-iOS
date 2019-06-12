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
    func createPage(_ image: UIImage, scaleTo: PageScaleSize = .A4) -> Result<PDFPage, WritePageError> {
        if let page = PDFPage(image: image) {
            page.setBounds(bounds(for: image, with: scaleTo), for: .mediaBox)
            return .success(page)
        } else {
            return .failure(WritePageError(state: .conversionError))
        }
    }

    // Generates a PDF from scanned images
    func savePDF(from pages: [PDFPage], fileName: String) -> Result<PDFFile, WritePDFError> {
        // Prevent writing of empty documents
        guard !pages.isEmpty else {
            return .failure(WritePDFError(state: .noPages))
        }
        let document = PDFDocument()
        pages.forEach { page in
            document.insert(page, at: document.pageCount)
        }
        let documentFile = PDFFile(fileName: fileName)
        if document.write(to: documentFile.url) {
            return .success(documentFile)
        } else {
            return .failure(WritePDFError(state: .writeError))
        }
    }

    // Delete a PDF
    // TODO: Combine these services
    func deletePDF(_ pdf: PDF) -> Result<Void, Error> {
        do {
            try FileManager.default.removeItem(at: getURL(from: pdf.fileName))
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    // Retrieves a PDF with a given name
    func getPDF(fileName: String) -> PDFDocument? {
        return PDFDocument(url: getURL(from: fileName))
    }

    private func getURL(from fileName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("pdf")
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
