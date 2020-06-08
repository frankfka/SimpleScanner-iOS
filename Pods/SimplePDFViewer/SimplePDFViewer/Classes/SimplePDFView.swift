//
//  PDFViewer.swift
//  PDFTest
//
//  Created by Frank Jia on 2019-05-19.
//  Copyright © 2019 Frank Jia. All rights reserved.
//

import UIKit
import PDFKit

protocol SimplePDFViewerStatusDelegate: AnyObject {
    func didLoadSuccessfully(_ sender: SimplePDFView)
    func didLoadWithError(_ sender: SimplePDFView)
    func onPageChange(_ sender: SimplePDFView)
}

class SimplePDFView: UIView {
    
    // State
    public private(set) var pdf: PDFDocument?
    public private(set) var currentPageNumber = 1
    
    // Views
    let pdfView: PDFView = PDFView()
    private var loadingSpinner: UIView?
    
    // Customizable properties
    var errorMessage = "Failed to load."
    weak var delegate: SimplePDFViewerStatusDelegate?
    var tint: UIColor? {
        didSet {
            pdfView.tintColor = tint
        }
    }
    
    // MARK: Constructors
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented. Please use the specified constructor.")
    }
    
    // MARK: Load methods
    
    // Loads a PDF given a URL string
    func load(urlString: String) {
        // Begin showing loading animation
        showSpinner()
        // Do loading on a background thread
        DispatchQueue.global(qos: .background).async {
            // Check whether load was successful
            if let url = URL(string: urlString), let pdf = PDFDocument(url: url) {
                // Loaded, update on main thread
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.initPDFView(pdf)
                    self.delegate?.didLoadSuccessfully(self)
                }
            } else {
                // Did not load
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showErrorMessage()
                    self.delegate?.didLoadWithError(self)
                }
            }
        }
    }
    // Loads a PDF given a URL
    func load(url: URL) {
        // Begin showing loading animation
        showSpinner()
        // Do loading on a background thread
        DispatchQueue.global(qos: .background).async {
            // Check whether load was successful
            if let pdf = PDFDocument(url: url) {
                // Loaded, update on main thread
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.initPDFView(pdf)
                    self.delegate?.didLoadSuccessfully(self)
                }
            } else {
                // Did not load
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showErrorMessage()
                    self.delegate?.didLoadWithError(self)
                }
            }
        }
    }
    // Loads a PDF given data
    func load(data: Data) {
        // Begin showing loading animation
        showSpinner()
        // Do loading on a background thread
        DispatchQueue.global(qos: .background).async {
            // Check whether load was successful
            if let pdf = PDFDocument(data: data) {
                // Loaded, update on main thread
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.initPDFView(pdf)
                    self.delegate?.didLoadSuccessfully(self)
                }
            } else {
                // Did not load
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showErrorMessage()
                    self.delegate?.didLoadWithError(self)
                }
            }
        }
    }
    // Loads a PDF given a PDFDocument
    func load(pdf: PDFDocument) {
        self.initPDFView(pdf)
        self.delegate?.didLoadSuccessfully(self)
    }
    
    // MARK: Helper functions
    
    // Jumps to the specified page
    func jumpToPage(_ pageNum: Int) {
        // page(at:) is a 0-based index
        guard let specifiedPage = pdf?.page(at: pageNum - 1) else {
            print("Invalid state - either PDF was not loaded or specified page is not in range")
            return
        }
        pdfView.go(to: specifiedPage)
    }
    
    // Initializes PDF view after document has loaded
    private func initPDFView(_ pdf: PDFDocument) {
        self.pdf = pdf
        
        pdfView.displayDirection = .vertical
        pdfView.displayMode = .singlePageContinuous
        pdfView.maxScaleFactor = 4
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.document = pdf
        addSubview(pdfView)
        pdfView.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        
        // Respond to page changes and update current page
        NotificationCenter.default.addObserver(self, selector: #selector(onPDFPageChanged), name: Notification.Name.PDFViewPageChanged, object: pdfView)
        updateCurrentPageNumber()
    }
    
    // Called when page state changes
    @objc private func onPDFPageChanged(notification: Notification) {
        updateCurrentPageNumber()
        self.delegate?.onPageChange(self)
    }
    
    // Updates the current page number of the view
    private func updateCurrentPageNumber() {
        if let pdf = pdf, let currentPage = pdfView.currentPage {
            currentPageNumber = pdf.index(for: currentPage) + 1
        }
    }
    
}

// MARK: Extension to show loading and error states
extension SimplePDFView {
    
    func showErrorMessage() {
        let errorLabel = UILabel()
        errorLabel.text = errorMessage
        errorLabel.textAlignment = .center
        
        self.addSubview(errorLabel)
        errorLabel.snp.makeConstraints() { make in
            make.edges.greaterThanOrEqualTo(UIEdgeInsets(top: 64, left: 64, bottom: 64, right: 64))
            make.center.equalToSuperview()
        }
    }
    
    func showSpinner() {
        let loadingAnimationView = UIView.init(frame: CGRect.zero)
        let spinner = UIActivityIndicatorView.init(style: .gray)
        
        loadingAnimationView.backgroundColor = .white
        loadingAnimationView.addSubview(spinner)
        
        self.addSubview(loadingAnimationView)
        
        loadingAnimationView.snp.makeConstraints() {make in
            make.edges.equalToSuperview()
        }
        spinner.snp.makeConstraints() { make in
            make.center.equalToSuperview()
        }
        
        loadingSpinner = loadingAnimationView
        spinner.startAnimating()
        spinner.center = loadingAnimationView.center
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.loadingSpinner?.removeFromSuperview()
            self.loadingSpinner = nil
        }
    }
    
}
