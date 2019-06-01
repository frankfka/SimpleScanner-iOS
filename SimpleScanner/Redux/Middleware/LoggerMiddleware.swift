//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

let loggerMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            // Log actions
            if action is CustomStringConvertible {
                print(action)
            } else {
                print(type(of: action))
            }
            // Proceed to next action
            next(action)
        }
    }
}