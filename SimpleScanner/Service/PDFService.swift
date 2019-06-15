//
// Created by Frank Jia on 2019-06-14.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import PDFKit
import RealmSwift

enum PageScaleSize {
    case none
    case A4
}

let A4Size: CGRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dp

class PDFService {

    static let shared = PDFService(databaseService: DatabaseService.shared, fileManagerService: FileManagerService.shared)

    private let databaseService: DatabaseService
    private let fileManagerService: FileManagerService

    init(databaseService: DatabaseService, fileManagerService: FileManagerService) {
        self.databaseService = databaseService
        self.fileManagerService = fileManagerService
    }

    // Creates a PDF page from a given image
    func createPage(_ image: UIImage, scaleTo: PageScaleSize = .A4) -> Result<PDFPage, PDFError> {
        if let page = PDFPage(image: image) {
            page.setBounds(bounds(for: image, with: scaleTo), for: .mediaBox)
            return .success(page)
        } else {
            return .failure(PDFError(state: .pageConversionError))
        }
    }

    // Saves a file to disk then the database
    func savePDF(from pages: [PDFPage], fileName: String) -> Result<PDF, PDFError> {
        switch fileManagerService.savePDFToDisk(from: pages, fileName: fileName) {
        case .success (let pdfFile):
            switch databaseService.addPDFToDatabase(pdfFile) {
            case .success (let pdf):
                return .success(pdf)
            case . failure (let writeError):
                return .failure(PDFError(state: .writeError, innerError: writeError))
            }
        case .failure (let writeError):
            return .failure(PDFError(state: .writeError, innerError: writeError))
        }
    }

    // Deletes a file from database then the disk
    func deletePDF(_ pdf: PDF) -> Result<Void, PDFError> {
        let fileName = pdf.fileName
        switch databaseService.deletePDFFromDatabase(pdf) {
        case .success:
            switch fileManagerService.deletePDFFromDisk(fileName: fileName) {
            case .success:
                return .success(())
            case .failure (let error):
                return .failure(PDFError(state: .deleteError, innerError: error))
            }
        case .failure (let error):
            return .failure(PDFError(state: .deleteError, innerError: error))
        }
    }

    func getPDFDocument(fileName: String) -> PDFDocument? {
        return self.fileManagerService.getPDFFromDisk(fileName: fileName)
    }

    func getAllPDFs() -> Results<PDF> {
        return databaseService.allDocuments()
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
