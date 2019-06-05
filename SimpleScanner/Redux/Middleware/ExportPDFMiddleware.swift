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
                let (pdf, error) = PDFService.shared.savePDF(from: action.pages, fileName: action.fileName)
                if let pdf = pdf {
                    DatabaseService.shared.addPDF(pdf) // TODO: use Rx here
                    dispatch(SaveDocumentSuccessAction(pdf: pdf))
                } else {
                    dispatch(SaveDocumentErrorAction(error: error))
                }
            }
        }
    }
}