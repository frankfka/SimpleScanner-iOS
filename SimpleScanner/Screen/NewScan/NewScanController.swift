//
// Created by Frank Jia on 2019-05-28.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import WeScan
import ReSwift
import SimplePDFViewer
import BFRImageViewer

class NewScanController: UIViewController {

    private let store: AppStore
    private var newScanView: NewScanView!
    private var cancelBarButton: UIBarButtonItem!
    private var saveBarButton: UIBarButtonItem!
    private var exportNameTextField: UITextField!

    public init(store: AppStore = appStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        // Title and Bar Button Items
        self.title = Text.NewScanTitle
        self.cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        self.saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        newScanView = NewScanView(viewModel: NewScanViewModel(from: store.state.newScanState),
                newPageTapped: newPageTapped,
                scannedPageTapped: scannedPageTapped,
                pageOrderSwitched: pageOrderSwitched)
        self.view = newScanView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.newScanState
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.dispatch(NewScanNavigateAwayAction())
        store.unsubscribe(self)
    }

    private func newPageTapped() {
        store.dispatch(AddPagePressedAction())
    }

    private func scannedPageTapped(index: Int) {
        store.dispatch(PageIconTappedAction(index: index))
    }

    private func pageOrderSwitched(original: Int, destination: Int) {
        store.dispatch(SwitchPageAction(originalIndex: original, destinationIndex: destination))
    }

    @objc private func cancelTapped() {
        store.dispatch(CancelNewScanAction())
    }

    @objc private func saveTapped() {
        let saveDialog = SavePDFDialog(presentingVC: self) { fileName in
            // Dispatch the save action with the specified file name
            self.store.dispatch(SaveDocumentPressedAction(
                    pages: self.store.state.newScanState.pages,
                    fileName: fileName)
            )
        }
        saveDialog.display()
    }
}

// Extension for WeScan
extension NewScanController: ImageScannerControllerDelegate {

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        store.dispatch(AddPageErrorAction(error: error))
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        let newPage: UIImage
        if let enhancedImage = results.enhancedImage, results.doesUserPreferEnhancedImage {
            newPage = enhancedImage
        } else {
            newPage = results.scannedImage
        }
        store.dispatch(AddPageScanSuccessAction(new: newPage))
        scanner.dismiss(animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        print("User cancelled scanning")
        scanner.dismiss(animated: true)
    }

}

// Extension for PDF Viewer
extension NewScanController: SimplePDFViewOnDismissDelegate {
    func didDismiss(_ sender: SimplePDFViewController) {
        sender.dismiss(animated: true) {
            self.store.dispatch(ExportedPDFViewDismissedAction())
        }
    }
}

// Extension for Store Subscriber
extension NewScanController: StoreSubscriber {

    public func newState(state: NewScanState) {

        // Handle State
        self.showAnimation(for: state.state, with: state.error?.displayStr)

        // Handle navigation
        if state.dismissNewScanVC {
            navigationController?.dismiss(animated: true)
        } else if state.showScanVC {
            // Create and launch a WeScan controller
            let scannerVC = ImageScannerController()
            scannerVC.navigationBar.backgroundColor = .white
            scannerVC.navigationBar.prefersLargeTitles = false
            scannerVC.navigationBar.tintColor = Color.NavTint
            scannerVC.imageScannerDelegate = self
            present(scannerVC, animated: true)
        } else if let pageIndex = state.showPageActionsWithIndex {
            // Launch dialog with delete & view actions
            let actionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionsController.addAction(UIAlertAction(title: Text.PageActionsView, style: .default) { _ in
                self.store.dispatch(PresentPageAction(index: pageIndex))
            })
            actionsController.addAction(UIAlertAction(title: Text.Delete, style: .destructive) { _ in
                self.store.dispatch(DeletePageAction(index: pageIndex))
            })
            actionsController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(actionsController, animated: true)
        } else if let pageIndex = state.showPageWithIndex {
            // Show image as a new VC
            let pageThumbnail = ImageService.shared.getThumbnailForPage(page: state.pages[pageIndex], width: UIScreen.main.bounds.width)
            present(BFRImageViewController(imageSource: [pageThumbnail])!, animated: true) //TODO: Build your own
        } else if let exportedPDF = state.exportedPDF {
            // Show exported PDF
            PDFViewer.show(pdf: exportedPDF, sender: self, dismissalDelegate: self)
        }

        // Update Views
        update(state: state)
    }

    private func update(state: NewScanState) {
        saveBarButton.isEnabled = !state.pages.isEmpty
        newScanView.update(viewModel: NewScanViewModel(from: state))
    }

}
