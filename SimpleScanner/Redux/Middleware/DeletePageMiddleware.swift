//
// Created by Frank Jia on 2019-06-01.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

let deletePDFMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            // Dispatch the current action FIRST, then perform the service
            next(action)
            if let action = action as? DeleteDocumentAction, let state = getState() {
                let service = PDFService.shared
                switch service.deletePDF(state.documentState.all[action.index]) {
                case .success:
                    dispatch(DeleteDocumentSuccessAction())
                case .failure(let error):
                    dispatch(DeleteDocumentErrorAction(error: error))
                }
            }
        }
    }
}