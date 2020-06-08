//
//  PDFViewController.swift
//  PDFTest
//
//  Created by Frank Jia on 2019-05-19.
//  Copyright © 2019 Frank Jia. All rights reserved.
//

import UIKit
import PDFKit

public protocol SimplePDFViewOnDismissDelegate: AnyObject {
    func didDismiss(_ sender: SimplePDFViewController)
}

public class SimplePDFViewController: UIViewController {
    
    // Views
    private let pdfView: SimplePDFView = SimplePDFView()
    private let topBar: SimplePDFTopBarView = SimplePDFTopBarView()
    private let bottomBar: SimplePDFBottomBarView = SimplePDFBottomBarView()
    
    // State
    private var currentPage = 1
    private var pdf: PDFDocument?
    
    // Configurable properties
    public var tint: UIColor? {
        didSet {
            pdfView.tint = tint
            topBar.tint = tint
            bottomBar.tint = tint
        }
    }
    public var errorMessage: String? {
        didSet {
            pdfView.errorMessage = errorMessage ?? ""
        }
    }
    public var viewTitle: String? {
        didSet {
            topBar.title = viewTitle ?? ""
            title = viewTitle
        }
    }
    public var exportPDFName: String = "Document"
    public var dismissalDelegate: SimplePDFViewOnDismissDelegate?
    
    // MARK: Constructors
    public init(urlString: String) {
        super.init(nibName:nil, bundle:nil)
        pdfView.load(urlString: urlString)
    }
    public init (url: URL) {
        super.init(nibName: nil, bundle: nil)
        pdfView.load(url: url)
    }
    public init (data: Data) {
        super.init(nibName: nil, bundle: nil)
        pdfView.load(data: data)
    }
    public init (pdf: PDFDocument) {
        super.init(nibName: nil, bundle: nil)
        pdfView.load(pdf: pdf)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initViews(withTopBar: navigationController == nil)
    }
    
    private func initViews(withTopBar: Bool) {
        let superview = self.view!
        superview.backgroundColor = .white
        superview.addSubview(pdfView)
        superview.addSubview(bottomBar)
        
        if withTopBar {
            // Add the top bar to view and add the necessary constraints
            superview.addSubview(topBar)
            topBar.snp.makeConstraints() { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            topBar.delegate = self
            // Make PDF View constrained to top bar
            pdfView.snp.makeConstraints() { make in
                make.top.equalTo(topBar.snp.bottom)
            }
        } else {
            // Make PDF View constrained to navbar
            pdfView.snp.makeConstraints() { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }
        }
        
        pdfView.snp.makeConstraints() { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        bottomBar.snp.makeConstraints() { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        pdfView.delegate = self
        bottomBar.delegate = self
        bottomBar.enabled = false
    }
    
}

// Delegates for different views
extension SimplePDFViewController: SimplePDFTopBarDelegate, SimplePDFBottomBarActionDelegate, SimplePDFViewerStatusDelegate {
    
    internal func doneButtonPressed(_ sender: SimplePDFTopBarView) {
        // Call delegate if it is set, else just dismiss
        if let dismissalDelegate = self.dismissalDelegate {
            dismissalDelegate.didDismiss(self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    internal func onShareButtonPressed(_ sender: SimplePDFBottomBarView) {
        guard let pdf = pdf else {
            print("PDF has not loaded yet, so cannot be shared.")
            return
        }
        // Disable bottom bar to prevent further touches
        bottomBar.enabled = false
        showShareSheet(for: pdf)
    }
    
    internal func onJumpToPagePressed(_ sender: SimplePDFBottomBarView) {
        guard let pdf = pdf else {
            print("PDF has not loaded yet.")
            return
        }
        showJumpToPageDialog(for: pdf)
    }
    
    internal func didLoadSuccessfully(_ sender: SimplePDFView) {
        self.pdf = sender.pdf
        bottomBar.enabled = true
        bottomBar.totalPages = pdf?.pageCount ?? 1
        bottomBar.currentPage = sender.currentPageNumber
    }
    
    internal func didLoadWithError(_ sender: SimplePDFView) {
        print("PDF Loaded with error")
        bottomBar.enabled = false // Just to be sure
    }
    
    internal func onPageChange(_ sender: SimplePDFView) {
        self.currentPage = sender.currentPageNumber
        bottomBar.currentPage = sender.currentPageNumber
    }
    
}

// Extension for presenting external VC's
extension SimplePDFViewController {
    
    // Shows a share sheet for the PDF
    private func showShareSheet(for pdf: PDFDocument) {
        // A local URL that we write to
        let shareURL = prepareForSharing(pdf: pdf, fileName: exportPDFName)
        let shareVC = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        present(shareVC, animated: true) {
            // Re-enable bottom bar
            self.bottomBar.enabled = true
        }
    }
    
    // Shows a dialog to enter a page number
    private func showJumpToPageDialog(for pdf: PDFDocument) {
        let dialogHelper = SimplePDFJumpToPageDialog(maxPages: pdf.pageCount, tint: tint ?? self.view.tintColor)
        let dialogVC = dialogHelper.getDialog(currentPage: currentPage) { newPageNum in
            if let pageNum = newPageNum {
                self.pdfView.jumpToPage(pageNum)
            }
        }
        present(dialogVC, animated: true, completion: nil)
    }
    
    // Writes PDF as a file so that we can share it
    private func prepareForSharing(pdf: PDFDocument, fileName: String) -> URL {
        let tempPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(fileName).pdf")
        let pdfData = pdf.dataRepresentation()
        FileManager.default.createFile(atPath: tempPath, contents: pdfData, attributes: nil)
        return URL(fileURLWithPath: tempPath)
    }
    
}

