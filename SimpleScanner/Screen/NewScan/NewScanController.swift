//
// Created by Frank Jia on 2019-05-28.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import WeScan

class NewScanController: UIViewController {

    private let store: AppStore
    private var newScanView: NewScanView!

    public init(store: AppStore = appStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.title = Text.NewScanTitle
        newScanView = NewScanView(newPageTapped: newPageTapped)
        self.view = newScanView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func newPageTapped() {
        // Create and launch a WeScan controller
        let scannerVC = ImageScannerController()
        scannerVC.navigationBar.backgroundColor = .white
        scannerVC.imageScannerDelegate = self
        present(scannerVC, animated: true)
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
        newScanView.tempImageView.image = results.scannedImage
        if (results.doesUserPreferEnhancedImage), let enhancedImage = results.enhancedImage {
            newScanView.tempImageView.image = enhancedImage
        }
        scanner.dismiss(animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }

}
