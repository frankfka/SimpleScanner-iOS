//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

let writePageToFileMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            // Dispatch the current action FIRST, then perform the service
            next(action)
            if let action = action as? AddPageScanSuccessAction {
                let (tempFile, error) = DocumentCreationService.shared.saveTemporaryPage(action.new)
                if let tempFile = tempFile {
                    dispatch(AddPageSuccessAction(new: tempFile))
                } else {
                    dispatch(AddPageErrorAction(error: error))
                }
            }
        }
    }
}