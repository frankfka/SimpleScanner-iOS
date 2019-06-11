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

    init(from pdf: PDF) {
        if let pdfDoc = PDFService.shared.getPDF(fileName: pdf.fileName),
           let thumbnail = ImageService.shared.getThumbnailForDocument(pdf: pdfDoc) {
            self.thumbnail = thumbnail
        } else {
            print("PDF Document with filename \(pdf.fileName) not found.")
            self.thumbnail = nil
        }
        fileName = pdf.fileName
        dateCreated = Text.DateString(for: pdf.dateCreated)
    }
}

class PDFCollectionViewCell: UICollectionViewCell {

    private var vm: PDFCollectionViewCellModel?
    private var cellView: UIView?
    private var thumbnail: UIImageView?
    private var fileNameLabel: UILabel?
    private var dateCreatedLabel: UILabel?

    func loadCell(with model: PDFCollectionViewCellModel) {
        self.vm = model
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
        let nameLabel = UILabel()
        let dateLabel = UILabel()

        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        thumbnailView.contentMode = .scaleAspectFit

        nameLabel.font = View.NormalFont
        nameLabel.textColor = Color.Text
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1

        dateLabel.font = View.SmallFont
        dateLabel.textColor = Color.LightText
        dateLabel.lineBreakMode = .byTruncatingTail
        dateLabel.numberOfLines = 1

        mainView.addSubview(thumbnailView)
        mainView.addSubview(nameLabel)
        mainView.addSubview(dateLabel)

        thumbnailView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-View.CollectionViewSubviewPadding)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(nameLabel.font.pointSize + View.TextLabelPadding)
            make.bottom.equalTo(dateLabel.snp.top)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(dateLabel.font.pointSize + 8)
            make.bottom.equalToSuperview()
        }

        self.cellView = mainView
        self.thumbnail = thumbnailView
        self.fileNameLabel = nameLabel
        self.dateCreatedLabel = dateLabel
    }

}
