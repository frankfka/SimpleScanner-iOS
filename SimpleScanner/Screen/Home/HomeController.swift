//
//  HomeController.swift
//  SimpleScanner
//
//  Created by Frank Jia on 2019-05-26.
//  Copyright © 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit

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
        homeView = HomeView()
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

