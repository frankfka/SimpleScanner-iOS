//
// Created by Frank Jia on 2019-05-28.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import WeScan

class NewScanController: UIViewController {

    private let store: AppStore
    private var newScanView: NewScanView!
    private var cancelBarButton: UIBarButtonItem!
    private var saveBarButton: UIBarButtonItem!

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
        newScanView = NewScanView(viewModel: NewScanViewModel(), newPageTapped: newPageTapped)
        self.view = newScanView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func newPageTapped() {
        // Create and launch a WeScan controller
        let scannerVC = ImageScannerController()
        scannerVC.navigationBar.backgroundColor = .white
        scannerVC.imageScannerDelegate = self
        present(scannerVC, animated: true)
    }

    @objc private func cancelTapped() {
        print("cancel")
    }

    @objc private func saveTapped() {
        print("save")
    }

}

// Extension for WeScan
extension NewScanController: ImageScannerControllerDelegate {

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
}

// Extension for Store Subscriber
extension NewScanController {}
