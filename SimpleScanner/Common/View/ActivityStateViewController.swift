//
// Created by Frank Jia on 2019-06-08.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit

// Handles state by showing the proper animation
extension UIViewController {

    func showAnimation(for state: ActivityState, with message: String? = nil) {
        // Handle State
        switch state {
        case .error:
            HUD.showError(message: message)
        case.loading:
            HUD.loading(show: true)
        case.none:
            HUD.loading(show: false)
        }
    }

}