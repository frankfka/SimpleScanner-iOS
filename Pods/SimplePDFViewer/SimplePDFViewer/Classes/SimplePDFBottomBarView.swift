//
//  PDFBottomBarView.swift
//  PDFTest
//
//  Created by Frank Jia on 2019-05-20.
//  Copyright © 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit

protocol SimplePDFBottomBarActionDelegate: AnyObject {
    func onShareButtonPressed(_ sender: SimplePDFBottomBarView)
    func onJumpToPagePressed(_ sender: SimplePDFBottomBarView)
}

class SimplePDFBottomBarView: UIView {

    private static let DISABLED_ALPHA = 0.4
    
    private var bottomBar: UIToolbar = UIToolbar()
    private var bottomBarPageCount: UILabel = UILabel()

    // Configurable properties
    weak var delegate: SimplePDFBottomBarActionDelegate?
    var enabled = false {
        didSet {
            bottomBar.isUserInteractionEnabled = enabled
            bottomBar.alpha = CGFloat(enabled ? 1 : SimplePDFBottomBarView.DISABLED_ALPHA)
        }
    }
    var tint: UIColor? {
        didSet {
            bottomBar.tintColor = tint
        }
    }
    var currentPage: Int = 1 {
        didSet {
            updatePageNumberView()
        }
    }
    var totalPages: Int = 1 {
        didSet {
            updatePageNumberView()
        }
    }
    
    init() {
        // Give a non-zero frame to initialize toolbar - correct size will be set when we create constraints
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        super.init(frame: frame)

        bottomBar = UIToolbar(frame: frame)
        bottomBarPageCount = UILabel()

        bottomBar.barTintColor = .white

        bottomBarPageCount.textAlignment = .center
        bottomBarPageCount.textColor = .darkText
        bottomBarPageCount.sizeToFit()

        let bottomBarShareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
        let bottomBarJumpToPageButton = UIBarButtonItem(title: "Jump To", style: .plain, target: self, action: #selector(jumpToPagePressed))
        let bottomBarItemPageNumber = UIBarButtonItem(customView: bottomBarPageCount)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bottomBar.setItems([bottomBarShareButton, flexibleSpace,
                            bottomBarItemPageNumber, flexibleSpace,
                            bottomBarJumpToPageButton], animated: false)

        addSubview(bottomBar)
        bottomBar.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func shareButtonPressed() {
        delegate?.onShareButtonPressed(self)
    }
    
    @objc private func jumpToPagePressed() {
        delegate?.onJumpToPagePressed(self)
    }

    private func updatePageNumberView() {
        bottomBarPageCount.text = "\(String(currentPage)) of \(String(totalPages))"
        bottomBarPageCount.sizeToFit()
    }
    
}
