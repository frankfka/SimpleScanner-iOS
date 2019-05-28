//
// Created by Frank Jia on 2019-05-27.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit

class HomeView: UIView {

    private var mainScrollView: UIScrollView!
    private var newScanButton: TextButton!

    init() {
        super.init(frame: CGRect.zero)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initSubviews() {
        backgroundColor = Color.BodyBackground

        // Main Scroll View
        mainScrollView = UIScrollView()
        addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges).inset(View.ViewPadding)
        }

        // New scan button
        newScanButton = TextButton(text: Text.NewScanButton) {
            print("Tapped")
        }
        mainScrollView.addSubview(newScanButton)
        newScanButton.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(View.SectionVerticalMargin)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
    }

}