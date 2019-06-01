//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit

class PageCollectionViewCellModel {
    let image: UIImage

    init(image: UIImage) {
        self.image = image
    }
}

class PageCollectionViewCell: UICollectionViewCell {

    func loadCell(with model: PageCollectionViewCellModel) {
        let imageView = UIImageView(image: model.image)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}
