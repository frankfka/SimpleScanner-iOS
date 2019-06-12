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
                switch PDFService.shared.savePDF(from: action.pages, fileName: action.fileName) {
                // Export to file successful
                case .success(let pdfFile):
                    switch DatabaseService.shared.addPDF(pdfFile) {
                    // Realm save successful
                    case .success(let pdf):
                        dispatch(SaveDocumentSuccessAction(pdf: pdf))
                    // Realm save failed
                    case .failure(let error):
                        dispatch(SaveDocumentErrorAction(error: error))
                    }
                // Export to file failed
                case .failure(let error):
                    dispatch(SaveDocumentErrorAction(error: error))
                }
            }
        }
    }
}