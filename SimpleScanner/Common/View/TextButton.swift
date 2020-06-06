//
// Created by Frank Jia on 2019-05-27.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit

class TextButton: UIView {

    var button: UIButton!
    let onTap: VoidCallback?

    init(text: String, onTap: VoidCallback? = nil) {
        self.onTap = onTap
        super.init(frame: CGRect.zero)

        button = UIButton(type: .system)
        button.backgroundColor = Color.Button
        button.contentEdgeInsets = UIEdgeInsets(top: ViewConstants.ButtonVerticalInset, left: ViewConstants.ButtonHorizontalInset, bottom: ViewConstants.ButtonVerticalInset, right: ViewConstants.ButtonHorizontalInset)
        button.layer.cornerRadius = ViewConstants.ButtonRadius
        button.titleLabel?.font = ViewConstants.ButtonFont
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        // Normal State
        button.setTitle(text, for: .normal)
        button.setTitleColor(Color.ButtonText, for: .normal)
        button.sizeToFit()
        addSubview(button)

        button.snp.makeConstraints { (make) in
            make.height.equalTo(ViewConstants.ButtonHeight)
            make.edges.equalToSuperview()
        }
    }

    @objc private func buttonTapped() {
        onTap?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
