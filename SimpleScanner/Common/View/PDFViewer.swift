//
// Created by Frank Jia on 2019-06-07.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import SimplePDFViewer

struct PDFViewer {

    static func show(pdf: PDF, sender: UIViewController, dismissalDelegate: SimplePDFViewOnDismissDelegate? = nil, completion: VoidCallback? = nil) {
        let pdfViewer = SimplePDFViewController(url: getDocumentsDirectory().appendingPathComponent(pdf.fileName).appendingPathExtension("pdf"))
        pdfViewer.dismissalDelegate = dismissalDelegate
        pdfViewer.errorMessage = TextConstants.PDFViewError
        pdfViewer.exportPDFName = pdf.fileName
        pdfViewer.viewTitle = pdf.fileName
        pdfViewer.tint = Color.NavTint
        pdfViewer.modalPresentationStyle = .fullScreen
        sender.present(pdfViewer, animated: true, completion: completion)
    }

}