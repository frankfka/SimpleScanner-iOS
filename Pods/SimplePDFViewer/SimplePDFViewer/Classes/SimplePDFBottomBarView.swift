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
    
    private let bottomBar: UIToolbar! = UIToolbar()
    private let bottomBarPageCount: UILabel! = UILabel()
    
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
        super.init(frame: CGRect.zero)
        
        let bottomBarItemPageNumber = UIBarButtonItem()
        bottomBarItemPageNumber.customView = bottomBarPageCount
        bottomBarPageCount.textAlignment = .center
        bottomBarPageCount.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomBarShareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
        let bottomBarJumpToPageButton = UIBarButtonItem(title: "Jump To", style: .plain, target: nil, action: #selector(jumpToPagePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bottomBar.setItems([bottomBarShareButton, flexibleSpace, bottomBarItemPageNumber, flexibleSpace, bottomBarJumpToPageButton], animated: false)
        
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
    }
    
}
