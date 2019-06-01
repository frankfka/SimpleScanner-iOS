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

class HomeController: UIViewController {

    private let store: AppStore
    private var homeView: HomeView!

    public init(store: AppStore = appStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.title = Text.HomeViewTitle
        homeView = HomeView(
                viewModel: HomeViewModel(state: store.state.homeState),
                newScanTapped: newScanTapped,
                itemTapped: itemTapped
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
        store.unsubscribe(self)
    }

    private func newScanTapped() {
        store.dispatch(AddNewDocumentTappedAction())
    }

    private func itemTapped(index: Int) {
        store.dispatch(DocumentTappedAction(index: index))
    }

}

// Redux Extension
extension HomeController: StoreSubscriber {

    public func newState(state: HomeState) {

        // Present new scan screen if state calls for it
        if state.showAddDocument {
            self.present(UINavigationController(rootViewController: NewScanController(store: appStore)), animated: true) { [weak self] in
                self?.store.dispatch(HomeNavigateAwayAction())
            }
        }

        // Present PDF if state calls for it
        if let docIndex = state.showDocumentWithIndex {
            // TODO present PDF
            self.store.dispatch(HomeNavigateAwayAction())
        }

        // Update Views
        homeView.update(viewModel: HomeViewModel(state: state))

    }

}


