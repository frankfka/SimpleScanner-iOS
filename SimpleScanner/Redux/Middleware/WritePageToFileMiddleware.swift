//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

let createPageMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            // Dispatch the current action FIRST, then perform the service
            next(action)
            if let action = action as? AddPageScanSuccessAction {
                let (page, error) = PDFService.shared.createPage(action.new)
                if let page = page {
                    dispatch(AddPageSuccessAction(new: page))
                } else {
                    dispatch(AddPageErrorAction(error: error))
                }
            }
        }
    }
}