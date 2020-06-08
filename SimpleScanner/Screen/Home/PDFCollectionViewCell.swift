//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import PDFKit

// Optional in case UIImage not loaded properly, in which case we display a blank
class PDFCollectionViewCellModel {
    let thumbnail: UIImage? //TODO: Specific error icon, make non-optional
    let fileName: String
    let dateCreated: String
    let index: Int

    init(from pdf: PDF, index: Int) {
        // Ideally we would want a cached lookup, so we're not getting multiple PDF documents at once..
        if let pdfDoc = PDFService.shared.getPDFDocument(fileName: pdf.fileName),
           let thumbnail = ImageService.shared.getThumbnailForDocument(pdf: pdfDoc) {
            self.thumbnail = thumbnail
        } else {
            print("PDF Document with filename \(pdf.fileName) not found.")
            self.thumbnail = nil
        }
        fileName = pdf.fileName
        dateCreated = TextConstants.DateString(for: pdf.dateCreated)
        self.index = index
    }
}

class PDFCollectionViewCell: UICollectionViewCell {

    private var onOptionsTap: TapIndexCallback?
    private var onThumbnailTap: TapIndexCallback?

    private var vm: PDFCollectionViewCellModel?
    private var cellView: UIView?
    private var thumbnail: UIImageView?
    private var fileNameLabel: UILabel?
    private var dateCreatedLabel: UILabel?

    func loadCell(with model: PDFCollectionViewCellModel,
                  onOptionsTap: @escaping TapIndexCallback,
                  onThumbnailTap: @escaping TapIndexCallback) {
        self.vm = model
        self.onOptionsTap = onOptionsTap
        self.onThumbnailTap = onThumbnailTap
        if cellView == nil {
            initSubviews()
        }
        loadSubviews()
    }

    private func loadSubviews() {
        thumbnail!.image = vm!.thumbnail
        fileNameLabel!.text = vm!.fileName
        dateCreatedLabel!.text = vm!.dateCreated
    }

    private func initSubviews() {
        let mainView = UIView()
        let thumbnailView = UIImageView()
        let showMore = UIImageView()
        let textViews = UIView()
        let nameLabel = UILabel()
        let dateLabel = UILabel()

        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        thumbnailView.contentMode = .scaleAspectFit
        thumbnailView.clipsToBounds = true
        showMore.contentMode = .scaleAspectFit
        showMore.image = UIImage(named: "Show More")

        nameLabel.font = ViewConstants.NormalFont
        nameLabel.textColor = Color.Text
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1

        dateLabel.font = ViewConstants.SmallFont
        dateLabel.textColor = Color.LightText
        dateLabel.lineBreakMode = .byTruncatingTail
        dateLabel.numberOfLines = 1

        textViews.addSubview(nameLabel)
        textViews.addSubview(dateLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(nameLabel.font.pointSize + ViewConstants.TextLabelPadding)
            make.bottom.equalTo(dateLabel.snp.top)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(dateLabel.font.pointSize + ViewConstants.TextLabelPadding)
            make.bottom.equalToSuperview()
        }

        mainView.addSubview(thumbnailView)
        mainView.addSubview(showMore)
        mainView.addSubview(textViews)

        thumbnailView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        textViews.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(thumbnailView.snp.bottom).offset(ViewConstants.CollectionViewSubviewPadding)
        }
        showMore.snp.makeConstraints { (make) in
            make.left.equalTo(textViews.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ViewConstants.CollectionViewSubviewPadding * 3)
            make.top.equalTo(thumbnailView.snp.bottom).offset(ViewConstants.CollectionViewSubviewPadding * 3)
            make.width.equalTo(showMore.snp.height)
        }
        thumbnailView.isUserInteractionEnabled = true
        thumbnailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped)))
        showMore.isUserInteractionEnabled = true
        showMore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMoreTapped)))

        self.cellView = mainView
        self.thumbnail = thumbnailView
        self.fileNameLabel = nameLabel
        self.dateCreatedLabel = dateLabel
    }

    @objc private func showMoreTapped() {
        if let cellIndex = vm?.index {
            onOptionsTap?(cellIndex)
        }
    }

    @objc private func thumbnailTapped() {
        if let cellIndex = vm?.index {
            onThumbnailTap?(cellIndex)
        }
    }

}
