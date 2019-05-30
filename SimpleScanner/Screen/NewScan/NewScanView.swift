//
// Created by Frank Jia on 2019-05-28.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import WeScan

class NewScanView: UIView {

    private let newPageTapped: VoidCallback

    // Temp
    let tempImageView: UIImageView!

    init(newPageTapped: @escaping VoidCallback) {
        self.newPageTapped = newPageTapped
        self.tempImageView = UIImageView()
        super.init(frame: CGRect.zero)

        backgroundColor = Color.BodyBackground

        let tempButton = TextButton(text: "Add Page", onTap: newPageTapped)
        addSubview(tempButton)

        tempButton.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        addSubview(tempImageView)
        tempImageView.contentMode = .scaleAspectFit
        tempImageView.snp.makeConstraints { (make) in
            make.top.equalTo(tempButton.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
