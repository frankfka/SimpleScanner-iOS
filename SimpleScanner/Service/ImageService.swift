//
// Created by Frank Jia on 2019-06-05.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class ImageService {

    static let shared = ImageService()
    static private let standardPage: CGRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dp

    // Get thumbnail for PDF
    func getThumbnail(pdf: PDFDocument, page: Int = 0, width: CGFloat = 256) -> UIImage? {
        if let page = pdf.page(at: page) {
            let imageMode = PDFDisplayBox.mediaBox
            let pageSize = page.bounds(for: imageMode)
            let pdfScale = width / pageSize.width

            // Apply if you're displaying the thumbnail on screen
            let scale = UIScreen.main.scale * pdfScale
            let screenSize = CGSize(width: pageSize.width * scale,
                    height: pageSize.height * scale)

            return page.thumbnail(of: screenSize, for: imageMode)
        }
        return nil
    }

    // Get a PDF page image from a scan
    func getPage(from scan: UIImage) -> UIImage {

    }

}
