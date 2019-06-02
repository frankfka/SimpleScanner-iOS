//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

// Optional in case UIImage not loaded properly, in which case we display a blank
class PageCollectionViewCellModel {
    let imageFile: TempFile

    init(imageFile: TempFile) {
        self.imageFile = imageFile
    }
}

class PageCollectionViewCell: UICollectionViewCell {

    private var imageView: UIImageView?

    func loadCell(with model: PageCollectionViewCellModel) {
        // Error state is plain black (UIImageView default) // TODO: specific error state
        if let imageView = imageView {
            load(imageURL: model.imageFile.url, into: imageView)
        } else {
            // Create new ImageView
            imageView = UIImageView()
            load(imageURL: model.imageFile.url, into: imageView!)
            imageView!.contentMode = .scaleAspectFit
            contentView.addSubview(imageView!)
            imageView!.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }

    // Uses Kingfisher to cache and load images
    private func load(imageURL: URL, into imageView: UIImageView) {
        let provider = LocalFileImageDataProvider(fileURL: imageURL)
        imageView.kf.setImage(with: provider)
    }

}
