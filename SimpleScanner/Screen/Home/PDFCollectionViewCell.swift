//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import PDFKit

// Optional in case UIImage not loaded properly, in which case we display a blank
class PDFCollectionViewCellModel {
    let thumbnail: UIImage?
    let name: String
    let dateCreated: String

    init(from pdf: PDF) {
        // TODO: can we cache?
        let pdfDoc = PDFDocument(url: URL(fileURLWithPath: pdf.path))! //TODO: error handling
        thumbnail = pdfDoc.page(at: 0)!.thumbnail(of: CGSize(width: 128, height: 128), for: .artBox)
        name = pdf.fileName
        dateCreated = "TODO"
    }
}

class PDFCollectionViewCell: UICollectionViewCell {

    private var imageView: UIImageView?

    func loadCell(with model: PDFCollectionViewCellModel) {
        // Error state is plain black (UIImageView default) // TODO: specific error state
        if let imageView = imageView {
            imageView.image = model.thumbnail
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
