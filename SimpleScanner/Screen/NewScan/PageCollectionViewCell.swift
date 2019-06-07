//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import PDFKit

// Optional in case UIImage not loaded properly, in which case we display a blank
class PageCollectionViewCellModel {
    let thumbnail: UIImage

    init(page: PDFPage) {
        self.thumbnail = ImageService.shared.getThumbnailForPage(page: page)
    }
}

class PageCollectionViewCell: UICollectionViewCell {

    private var imageView: UIImageView?

    func loadCell(with model: PageCollectionViewCellModel) {
        // Error state is plain black (UIImageView default) // TODO: specific error state
        if imageView == nil {
            // Create new ImageView
            imageView = UIImageView()
            imageView!.contentMode = .scaleAspectFit
            contentView.addSubview(imageView!)
            imageView!.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        imageView?.image = model.thumbnail
    }

}
