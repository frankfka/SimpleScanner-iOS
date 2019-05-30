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

    // Collection View
    static let CollectionViewItemsPerRow: CGFloat = 2
    static let CollectionViewSectionInsets = UIEdgeInsets(top: SectionVerticalMargin, left: ViewPadding, bottom: SectionVerticalMargin, right: ViewPadding)
    static let CollectionViewSize: CGSize = {
        get {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow

            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }

}
