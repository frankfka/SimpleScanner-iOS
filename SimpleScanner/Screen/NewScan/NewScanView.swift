//
// Created by Frank Jia on 2019-05-28.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import WeScan

// Simple VM for the class
class NewScanViewModel {
    let enableEdit: Bool
    let pages: [TempFile]

    init(from state: NewScanState) {
        self.pages = state.pages
        self.enableEdit = (state.state == .none)
    }
}

class NewScanView: UIView {

    private var vm: NewScanViewModel

    // UI
    private var newScanButton: TextButton!
    private var bottomBar: UIView!
    private var pagesCollectionView: UICollectionView!

    // Callbacks
    private let newPageTapped: VoidCallback
    private let scannedPageTapped: TapIndexCallback

    init(viewModel: NewScanViewModel, newPageTapped: @escaping VoidCallback, scannedPageTapped: @escaping TapIndexCallback) {
        self.vm = viewModel
        self.newPageTapped = newPageTapped
        self.scannedPageTapped = scannedPageTapped
        super.init(frame: CGRect.zero)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(viewModel: NewScanViewModel) {
        self.vm = viewModel
        newScanButton.isUserInteractionEnabled = vm.enableEdit
        pagesCollectionView.reloadData()
    }

}

// Extension for Collection View
// UICollectionView Delegate
extension NewScanView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.pages.count
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return View.PagesCollectionViewSize(frameWidth: collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageCell = collectionView.dequeueReusableCell(withReuseIdentifier: View.PageCollectionCellReuseID, for: indexPath) as! PageCollectionViewCell
        let cellModel = PageCollectionViewCellModel(imageFile: vm.pages[indexPath.row])
        pageCell.loadCell(with: cellModel)
        return pageCell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scannedPageTapped(indexPath.row)
    }
}

// Extension for init
extension NewScanView {

    private func initSubviews() {
        backgroundColor = Color.BodyBackground
        initBottomBar()
        initPagesCollectionView()
    }

    private func initBottomBar() {
        // Bottom Bar View With Add Button
        bottomBar = UIView()
        bottomBar.backgroundColor = Color.BodyBackgroundContrast
        // New Scan Button
        newScanButton = TextButton(text: Text.AddPageButton, onTap: newPageTapped)
        bottomBar.addSubview(newScanButton)
        addSubview(bottomBar)
        newScanButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(View.SectionVerticalMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(View.SectionVerticalMargin)
            make.left.equalToSuperview().inset(View.ViewPadding)
            make.right.equalToSuperview().inset(View.ViewPadding)
            make.centerX.equalToSuperview()
        }
        bottomBar.sizeToFit()
        bottomBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func initPagesCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = View.PagesCollectionViewSectionInsets
        pagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        pagesCollectionView.backgroundColor = Color.BodyBackground
        pagesCollectionView.delegate = self
        pagesCollectionView.dataSource = self
        pagesCollectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: View.PageCollectionCellReuseID)
        addSubview(pagesCollectionView)
        pagesCollectionView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
            make.top.equalToSuperview()
        }
    }

}