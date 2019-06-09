//
// Created by Frank Jia on 2019-05-27.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import UIKit

class View {

    // General
    static let ViewPadding: CGFloat = 16
    static let SectionVerticalMargin: CGFloat = 24
    static let SubSectionVerticalMargin: CGFloat = 8

    // Divider
    static let DividerHeight: CGFloat = 1

    // Buttons
    static let ButtonHorizontalInset: CGFloat = 64
    static let ButtonVerticalInset: CGFloat = 16
    static let ButtonRadius: CGFloat = 25
    static let ButtonHeight: CGFloat = 50

    // Fonts
    static let NormalFont: UIFont = .systemFont(ofSize: 16)
    static let ButtonFont: UIFont = .systemFont(ofSize: 20)
    static let HeaderFont: UIFont = .systemFont(ofSize: 36)

    static let CollectionViewVerticalMargin: CGFloat = 48
    // Document Collection View
    static let DocumentCollectionViewItemsPerRow: CGFloat = 2
    static let DocumentCollectionViewSectionInsets = UIEdgeInsets(top: CollectionViewVerticalMargin, left: ViewPadding, bottom: CollectionViewVerticalMargin, right: ViewPadding)
    static func DocumentCollectionViewSize(frameWidth: CGFloat) -> CGSize {
        let widthPerItem = computeCollectionViewCellWidth(frameWidth: frameWidth, insets: DocumentCollectionViewSectionInsets, itemsPerRow: DocumentCollectionViewItemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    static let DocumentCollectionCellReuseID: String = "DocumentCell"

    // Pages Collection View
    static let PagesCollectionViewItemsPerRow: CGFloat = 2
    static let PagesCollectionViewSectionInsets = UIEdgeInsets(top: CollectionViewVerticalMargin, left: ViewPadding, bottom: CollectionViewVerticalMargin, right: ViewPadding)
    static func PagesCollectionViewSize(frameWidth: CGFloat) -> CGSize {
        let widthPerItem = computeCollectionViewCellWidth(frameWidth: frameWidth, insets: PagesCollectionViewSectionInsets, itemsPerRow: PagesCollectionViewItemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    static let PageCollectionCellReuseID: String = "PageCell"
    static let AddPageCollectionCellReuseID: String = "AddPageCell" // Not being used

    // Computes width of a collection view cell
    private static func computeCollectionViewCellWidth(frameWidth: CGFloat, insets: UIEdgeInsets, itemsPerRow: CGFloat) -> CGFloat {
        let paddingSpace = insets.left * (itemsPerRow + 1)
        let availableWidth = frameWidth - paddingSpace
        return availableWidth / itemsPerRow
    }
}
