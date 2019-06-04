//
// Created by Frank Jia on 2019-06-03.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import SVProgressHUD

class HUD {

    private static let DisplayDuration = TimeInterval(exactly: 3)!

    static func loading(show: Bool) {
        if show {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }

    static func showSuccess(message: String? = nil) {
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: HUD.DisplayDuration)
    }

    static func showError(message: String? = nil) {
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.dismiss(withDelay: HUD.DisplayDuration)
    }

}
