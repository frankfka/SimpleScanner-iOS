//
//  PDFTopBarView.swift
//  PDFTest
//
//  Created by Frank Jia on 2019-05-20.
//  Copyright © 2019 Frank Jia. All rights reserved.
//

import Foundation
import UIKit

protocol SimplePDFTopBarDelegate: AnyObject {
    func doneButtonPressed(_ sender: SimplePDFTopBarView)
}

class SimplePDFTopBarView: UIView {
    
    private let topBar: UINavigationBar! = UINavigationBar()
    private let topBarItems: UINavigationItem! = UINavigationItem()
    
    // Configurable properties
    weak var delegate: SimplePDFTopBarDelegate?
    var title: String = "PDF" {
        didSet {
            topBarItems.title = title
        }
    }
    var tint: UIColor? {
        didSet {
            topBar.tintColor = tint
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        let topBarDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneButtonTapped))
        
        topBarItems.title = title
        topBarItems.rightBarButtonItem = topBarDone
        topBar.setItems([topBarItems], animated: false)
        topBar.backgroundColor = .white
        topBar.isTranslucent = false
        
        addSubview(topBar)
        topBar.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented. Please use the specified constructor.")
    }
    
    @objc private func doneButtonTapped() {
        delegate?.doneButtonPressed(self)
    }
    
}
