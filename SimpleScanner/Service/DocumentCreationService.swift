//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import PDFKit

class DocumentCreationService {

    static let shared = DocumentCreationService()

    // Saves a page to disk and returns URL
    func saveTemporaryPage(_ image: UIImage) -> (TempFile?, Error?) {
        guard let imgData = image.pngData() else {
            return (nil, WriteTempPageError(state: .pngDataConversionError, innerError: nil))
        }
        let tempFile = TempFile(extension: "png")
        do {
            try imgData.write(to: tempFile.url, options: .atomic)
            return (tempFile, nil)
        } catch {
            return (nil, WriteTempPageError(state: .writeError, innerError: error))
        }
    }

    // Generates a PDF from scanned images
    func generatePDF(from imageFiles: [TempFile], fileName: String) -> (PDFFile?, WritePDFError?) {
        let document = PDFDocument()
        var erroredPages: [Int] = []
        imageFiles.forEach { file in
            if let pageImage = UIImage(contentsOfFile: file.url.path), let page = PDFPage(image: pageImage) {
                document.insert(page, at: document.pageCount)
            } else {
                erroredPages.append(document.pageCount)
            }
        }
        // Prevent writing of empty documents
        guard document.pageCount > 0 else {
            return (nil, WritePDFError(erroredPages: erroredPages, state: .noPages))
        }
        let documentFile = PDFFile(fileName: fileName)
        if document.write(to: documentFile.url) {
            return (documentFile, erroredPages.isEmpty ? nil : WritePDFError(erroredPages: erroredPages, state: .missingPages))
        } else {
            return (nil, WritePDFError(erroredPages: erroredPages, state: .writeError))
        }
    }

    // Creates a file name based on time
    static func getDefaultFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMMdd_HH-mm_ss"
        let dateString = dateFormatter.string(from: Date())
        return "SimpleScanner_\(dateString)"
    }

}
