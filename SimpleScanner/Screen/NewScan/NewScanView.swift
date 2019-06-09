//
// Created by Frank Jia on 2019-05-28.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit
import SnapKit
import WeScan
import PDFKit

// Simple VM for the class
class NewScanViewModel {
    let enableEdit: Bool
    let pages: [PDFPage]

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
        let cellModel = PageCollectionViewCellModel(page: vm.pages[indexPath.row], pageNum: indexPath.row + 1, totalPages: vm.pages.count)
        pageCell.loadCell(with: cellModel)
        return pageCell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scannedPageTapped(indexPath.row)
    }
}

// Drag & Drop Functionality
extension NewScanView: UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let page = vm.pages[indexPath.row]
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = page
        return [dragItem]
    }

    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }

    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                let temp = vm.pages[sourceIndexPath.row]
                vm.pages.remove(at: sourceIndexPath.row)
                vm.pages.insert(temp, at: dIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(item.dragItem, toItemAt: dIndexPath)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil && collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
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
        pagesCollectionView.dragInteractionEnabled = true
        pagesCollectionView.dropDelegate = self
        pagesCollectionView.dragDelegate = self
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