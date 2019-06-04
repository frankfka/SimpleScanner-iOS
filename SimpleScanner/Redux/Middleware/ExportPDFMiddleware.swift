//
// Created by Frank Jia on 2019-06-02.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import ReSwift

let exportPDFMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            // Dispatch action FIRST, then call the service
            next(action)
            if let action = action as? SaveDocumentPressedAction {
                let (pdf, error) = DocumentCreationService.shared.generatePDF(from: action.pages, fileName: action.fileName)
                if let pdf = pdf {
                    dispatch(SaveDocumentSuccessAction(pdf: pdf))
                } else {
                    dispatch(SaveDocumentErrorAction(error: error))
                }
            }
        }
    }
}