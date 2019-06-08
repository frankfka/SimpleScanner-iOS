//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import PDFKit

// Optional in case UIImage not loaded properly, in which case we display a blank
class PDFCollectionViewCellModel {
    let thumbnail: UIImage?
    let name: String
    let dateCreated: String

    init(from pdf: PDF) {
        if let pdfDoc = PDFService.shared.getPDF(fileName: pdf.fileName),
           let thumbnail = ImageService.shared.getThumbnailForDocument(pdf: pdfDoc) {
            self.thumbnail = thumbnail
        } else {
            print("PDF Document with filename \(pdf.fileName) not found.")
            self.thumbnail = nil
        }
        name = pdf.fileName
        dateCreated = "TODO"
    }
}

class PDFCollectionViewCell: UICollectionViewCell {

    private var imageView: UIImageView?

    func loadCell(with model: PDFCollectionViewCellModel) {
        if let imageView = imageView {
            imageView.image = model.thumbnail // TODO: specific error placeholder
        } else {
            // Create new ImageView
            imageView = UIImageView()
            imageView!.image = model.thumbnail
            imageView!.contentMode = .scaleAspectFit
            contentView.addSubview(imageView!)
            imageView!.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }

}
