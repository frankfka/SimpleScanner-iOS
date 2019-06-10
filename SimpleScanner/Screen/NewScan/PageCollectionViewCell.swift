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
    let page: Int
    let totalPages: Int

    init(page: PDFPage, pageNum: Int, totalPages: Int) {
        self.page = pageNum
        self.totalPages = totalPages
        self.thumbnail = ImageService.shared.getThumbnailForPage(page: page)
    }
}

class PageCollectionViewCell: UICollectionViewCell {

    private var vm: PageCollectionViewCellModel?
    private var cellView: UIView?
    private var pageThumbnail: UIImageView?
    private var pageLabel: UILabel?

    override func prepareForReuse() {
        super.prepareForReuse()
        pageThumbnail?.image = nil
        pageLabel?.text = nil
    }

    func loadCell(with model: PageCollectionViewCellModel) {
        // Error state is plain black (UIImageView default) // TODO: specific error state
        self.vm = model
        if cellView == nil {
            initSubviews()
        }
        loadSubviews()
    }

    private func loadSubviews() {
        pageThumbnail!.image = vm!.thumbnail
        pageLabel!.text = Text.PageCellNumberLabel(currentPage: vm!.page, totalPages: vm!.totalPages)
    }

    private func initSubviews() {
        let mainView = UIView()
        let thumbnailView = UIImageView()
        let pageNumLabel = UILabel()

        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        pageNumLabel.font = View.NormalFont
        pageNumLabel.textColor = Color.Text
        pageNumLabel.textAlignment = .center
        thumbnailView.contentMode = .scaleAspectFit
        mainView.addSubview(thumbnailView)
        mainView.addSubview(pageNumLabel)
        pageNumLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(View.NormalFont.pointSize + 8)
        }
        thumbnailView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(pageNumLabel.snp.top)
        }

        self.cellView = mainView
        self.pageThumbnail = thumbnailView
        self.pageLabel = pageNumLabel
    }

}
