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
        button.contentEdgeInsets = UIEdgeInsets(top: View.ButtonVerticalInset, left: View.ButtonHorizontalInset, bottom: View.ButtonVerticalInset, right: View.ButtonHorizontalInset)
        button.layer.cornerRadius = View.ButtonRadius
        button.titleLabel?.font = View.ButtonFont
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        // Normal State
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.sizeToFit()
        addSubview(button)

        button.snp.makeConstraints { (make) in
            make.height.equalTo(View.ButtonHeight)
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
