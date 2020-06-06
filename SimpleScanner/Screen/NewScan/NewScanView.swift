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
    private let pageOrderSwitched: PageSwitchCallback

    init(viewModel: NewScanViewModel, newPageTapped: @escaping VoidCallback, scannedPageTapped: @escaping TapIndexCallback, pageOrderSwitched: @escaping PageSwitchCallback) {
        self.vm = viewModel
        self.newPageTapped = newPageTapped
        self.scannedPageTapped = scannedPageTapped
        self.pageOrderSwitched = pageOrderSwitched
        super.init(frame: CGRect.zero)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(viewModel: NewScanViewModel) {
        self.vm = viewModel
        newScanButton.isUserInteractionEnabled = vm.enableEdit
        self.pagesCollectionView.endInteractiveMovement()
        DispatchQueue.main.async {
            self.pagesCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }

}

// Extension for Collection View
// UICollectionView Delegate
extension NewScanView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.pages.count
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ViewConstants.PagesCollectionViewSize(frameWidth: collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewConstants.PageCollectionCellReuseID, for: indexPath) as! PageCollectionViewCell
        let cellModel = PageCollectionViewCellModel(page: vm.pages[indexPath.row], pageNum: indexPath.row + 1, totalPages: vm.pages.count)
        pageCell.loadCell(with: cellModel)
        pageCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:))))
        return pageCell
    }

    @objc private func cellTapped(sender: UITapGestureRecognizer) {
        let indexPath = self.pagesCollectionView.indexPathForItem(at: sender.location(in: self.pagesCollectionView))
        if let indexPath = indexPath {
            scannedPageTapped(indexPath.row)
        }
    }

}

// Drag & Drop, Delete Functionality
extension NewScanView: UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = vm.pages[indexPath.row]
        return [dragItem]
    }

    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // Get index path of destination if it exists, or just select the last item's index path
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: vm.pages.count, section: 0)
        // Only perform move operations
        switch coordinator.proposal.operation {
        case .move:
            // Get the original index path of the item
            if let dragItem = coordinator.items.first, let originalIndexPath = dragItem.sourceIndexPath {
                // Get destination index path, making sure that we don't get an out of bounds error
                let destinationIndexPathRow = (destinationIndexPath.row >= vm.pages.count) ? vm.pages.count - 1 : destinationIndexPath.row
                // Perform the updates
                collectionView.performBatchUpdates({
                    self.pageOrderSwitched(originalIndexPath.row, destinationIndexPathRow)
                    collectionView.deleteItems(at: [originalIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }, completion: { _ in
                    coordinator.drop(dragItem.dragItem, toItemAt: destinationIndexPath)
                })
            }
            break
        default:
            return
        }
    }

    // Returns a Drop Proposal to be used
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // Only allow drag & drop within the same collection view within the same app
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
        newScanButton = TextButton(text: TextConstants.AddPageButton, onTap: newPageTapped)
        bottomBar.addSubview(newScanButton)
        addSubview(bottomBar)
        newScanButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(ViewConstants.SectionVerticalMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(ViewConstants.SectionVerticalMargin)
            make.left.equalToSuperview().inset(ViewConstants.ViewPadding)
            make.right.equalToSuperview().inset(ViewConstants.ViewPadding)
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
        flowLayout.minimumLineSpacing = ViewConstants.CollectionViewCellVerticalMargin
        flowLayout.sectionInset = ViewConstants.PagesCollectionViewSectionInsets
        pagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        pagesCollectionView.backgroundColor = Color.BodyBackground
        pagesCollectionView.dragInteractionEnabled = true
        pagesCollectionView.dropDelegate = self
        pagesCollectionView.dragDelegate = self
        pagesCollectionView.delegate = self
        pagesCollectionView.dataSource = self
        pagesCollectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: ViewConstants.PageCollectionCellReuseID)
        addSubview(pagesCollectionView)
        pagesCollectionView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
            make.top.equalToSuperview()
        }
    }

}