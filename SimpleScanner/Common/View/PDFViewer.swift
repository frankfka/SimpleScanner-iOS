//
// Created by Frank Jia on 2019-06-07.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import SimplePDFViewer

class PDFViewer {

    static func show(pdf: PDF, sender: UIViewController, dismissalDelegate: SimplePDFViewOnDismissDelegate? = nil, completion: VoidCallback? = nil) {
        let pdfViewer = SimplePDFViewController(url: getDocumentsDirectory().appendingPathComponent(pdf.fileName).appendingPathExtension("pdf"))
        pdfViewer.dismissalDelegate = dismissalDelegate
        pdfViewer.errorMessage = Text.PDFViewError
        pdfViewer.exportPDFName = pdf.fileName
        pdfViewer.tint = Color.Primary
        sender.present(pdfViewer, animated: true, completion: completion)
    }

}