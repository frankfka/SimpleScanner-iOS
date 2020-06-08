//
//  HomeController.swift
//  SimpleScanner
//
//  Created by Frank Jia on 2019-05-26.
//  Copyright © 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import ReSwift
import SimplePDFViewer
import RealmSwift

class HomeController: UIViewController {

    private let store: AppStore
    private var homeView: HomeView!
    private var vm: HomeViewModel

    public init(store: AppStore = appStore) {
        self.store = store
        self.vm = HomeViewModel(state: store.state.homeState, documents: store.state.documentState.all)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.title = TextConstants.HomeViewTitle
        homeView = HomeView(
            viewModel: self.vm,
            newScanTapped: newScanTapped,
            showPDFTapped: showPDFTapped,
            showPDFOptionsTapped: showPDFOptionsTapped
        )
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) {
            $0.select {
                $0.homeState
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.dispatch(HomeNavigateAwayAction())
        store.unsubscribe(self)
    }

    private func newScanTapped() {
        store.dispatch(AddNewDocumentTappedAction())
    }

    private func showPDFTapped(index: Int) {
        store.dispatch(ShowDocumentTappedAction(index: index))
    }

    private func showPDFOptionsTapped(index: Int) {
        store.dispatch(ShowDocumentOptionsTappedAction(index: index))
    }

    private func deletePDFTapped(index: Int) -> (UIAlertAction) -> Void {
        return { _ in
            self.store.dispatch(DeleteDocumentAction(index: index))
        }
    }

}

// Redux Extension
extension HomeController: StoreSubscriber {

    public func newState(state: HomeState) {
        // Handle State
        self.showAnimation(for: state.state)

        self.vm = HomeViewModel(state: state, documents: vm.documents)
        if state.showAddDocument {
            // Present new scan screen if state calls for it
            let newScanVc = UINavigationController(rootViewController: NewScanController(store: appStore))
            newScanVc.modalPresentationStyle = .fullScreen
            self.present(newScanVc, animated: true)
        } else if let docIndex = state.showDocumentOptionsWithIndex {
            // Note: This breaks constraints - known bug in ios 13.5
            // Present document options if state calls for it
            let documentOptionsDialog = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            documentOptionsDialog.addAction(UIAlertAction(title: TextConstants.Delete, style: .destructive, handler: deletePDFTapped(index: docIndex)))
            documentOptionsDialog.addAction(UIAlertAction(title: TextConstants.Cancel, style: .cancel))
            self.present(documentOptionsDialog, animated: true)
        } else if let docIndex = state.showDocumentWithIndex {
            // Present PDF if state calls for it
            PDFViewer.show(pdf: vm.documents[docIndex], sender: self)
        }
        // Update Views
        homeView.update(viewModel: self.vm)
    }

}


