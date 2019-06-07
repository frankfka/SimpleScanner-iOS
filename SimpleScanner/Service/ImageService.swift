//
// Created by Frank Jia on 2019-06-05.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class ImageService {

    static let shared = ImageService()

    // Get thumbnail for PDF
    func getThumbnailForDocument(pdf: PDFDocument, page: Int = 0, width: CGFloat = 256) -> UIImage? {
        if let page = pdf.page(at: page) {
            return getThumbnailForPage(page: page, width: width)
        }
        return nil
    }

    func getThumbnailForPage(page: PDFPage, width: CGFloat = 256) -> UIImage {
        let imageMode = PDFDisplayBox.mediaBox
        let pageSize = page.bounds(for: imageMode)
        let pdfScale = width / pageSize.width

        // Apply if you're displaying the thumbnail on screen
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                height: pageSize.height * scale)

        return page.thumbnail(of: screenSize, for: imageMode)
    }

}
