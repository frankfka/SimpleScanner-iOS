//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import PDFKit

class FileManagerService {

    static let shared = FileManagerService()

    // Creates a file name based on time
    static func getDefaultFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMMdd_HH-mm_ss"
        let dateString = dateFormatter.string(from: Date())
        return "SimpleScanner_\(dateString)"
    }

    // Generates a PDF from scanned images
    func savePDFToDisk(from pages: [PDFPage], fileName: String) -> Result<PDFFile, FileManagerError> {
        // Prevent writing of empty documents
        guard !pages.isEmpty else {
            return .failure(FileManagerError(state: .noPages, innerError: nil))
        }
        let document = PDFDocument()
        pages.forEach { page in
            document.insert(page, at: document.pageCount)
        }
        let documentFile = PDFFile(fileName: fileName)
        if document.write(to: documentFile.url) {
            return .success(documentFile)
        } else {
            return .failure(FileManagerError(state: .writeError, innerError: nil))
        }
    }

    // Delete a PDF
    func deletePDFFromDisk(fileName: String) -> Result<Void, Error> {
        do {
            try FileManager.default.removeItem(at: getURL(from: fileName))
            return .success(())
        } catch {
            return .failure(FileManagerError(state: .deleteError, innerError: error))
        }
    }

    // Retrieves a PDF with a given name
    func getPDFFromDisk(fileName: String) -> PDFDocument? {
        return PDFDocument(url: getURL(from: fileName))
    }

    private func getURL(from fileName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("pdf")
    }


}
