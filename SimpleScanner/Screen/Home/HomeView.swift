//
// Created by Frank Jia on 2019-05-27.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit

class HomeView: UIView {

    private var vm: HomeViewModel

    // UI
    private var newScanButton: TextButton!
    private var bottomBar: UIView!
    private var documentCollectionView: UICollectionView!

    // Callbacks
    private let newScanTapped: VoidCallback
    private let itemTapped: TapIndexCallback

    init(viewModel: HomeViewModel, newScanTapped: @escaping VoidCallback, itemTapped: @escaping TapIndexCallback) {
        self.vm = viewModel
        self.newScanTapped = newScanTapped
        self.itemTapped = itemTapped
        super.init(frame: CGRect.zero)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(viewModel: HomeViewModel) {
        self.vm = viewModel
        // Do other updating here
    }

}

// UICollectionView Delegate
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.documents.count
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return View.CollectionViewSize(frameWidth: collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: View.DocumentCollectionCellReuseID, for: indexPath)
        myCell.backgroundColor = UIColor.blue
        return myCell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.itemTapped(indexPath.row)
    }
}

// Initialization
extension HomeView {

    // Main initialization block
    private func initSubviews() {
        backgroundColor = Color.BodyBackground
        initBottomBar()
        initDocumentCollectionView()
    }

    private func initBottomBar() {
        // Bottom Bar View With Add Button
        bottomBar = UIView()
        bottomBar.backgroundColor = Color.BodyBackgroundContrast
        // New Scan Button
        newScanButton = TextButton(text: Text.NewScanButton, onTap: newScanTapped)
        bottomBar.addSubview(newScanButton)
        addSubview(bottomBar)
        newScanButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(View.SectionVerticalMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(View.SectionVerticalMargin)
            make.left.greaterThanOrEqualToSuperview().inset(View.ViewPadding)
            make.right.lessThanOrEqualToSuperview().inset(View.ViewPadding)
            make.centerX.equalToSuperview()
        }
        bottomBar.sizeToFit()
        bottomBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func initDocumentCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = View.CollectionViewSectionInsets
        documentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        documentCollectionView.backgroundColor = Color.BodyBackground
        documentCollectionView.delegate = self
        documentCollectionView.dataSource = self
        documentCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: View.DocumentCollectionCellReuseID)
        addSubview(documentCollectionView)
        documentCollectionView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
            make.top.equalToSuperview()
        }
    }
}
