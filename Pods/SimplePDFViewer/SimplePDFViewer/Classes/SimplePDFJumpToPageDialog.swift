//
//  PDFJumpToPageDialog.swift
//  PDFTest
//
//  Created by Frank Jia on 2019-05-21.
//  Copyright © 2019 Frank Jia. All rights reserved.
//

import UIKit

// A separate class that provides a dialog
class SimplePDFJumpToPageDialog: NSObject {
    
    private let maxPages: Int
    private let tint: UIColor
    private var specifiedPage: Int?
    
    init(maxPages: Int, tint: UIColor) {
        self.maxPages = maxPages
        self.tint = tint
    }
    
    // If the passed integer is nil, no valid number was entered
    func getDialog(currentPage: Int, onSubmit: @escaping (Int?) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: "Jump to Page", message: "Specify a page number between 1 and \(maxPages)", preferredStyle: .alert)
        alertController.addTextField() { textField in
            textField.delegate = self
            textField.tintColor = self.tint
            textField.keyboardType = .numberPad
            textField.text = String(currentPage)
        }
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Confirm action
        alertController.addAction(UIAlertAction(title: "Go", style: .default) { action in
            onSubmit(self.specifiedPage)
        })
        alertController.view.tintColor = tint
        return alertController
    }
    
}

extension SimplePDFJumpToPageDialog: UITextFieldDelegate {
    
    // Only allow positive numerical inputs
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Get the full string ("string" is only the current change)
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let parsedNumber = getValidNumber(newText)
        
        // We'll try to parse the new number to update the field
        if let number = parsedNumber {
            specifiedPage = number
            return true
        } else if string.isEmpty {
            // Empty is when user has pressed delete key - should always return true
            specifiedPage = nil
            return true
        }
        
        // Not a valid change
        specifiedPage = nil
        return false
    }
    
    // Checks if a string is a number within the page range and returns that number, or nil if invalid
    private func getValidNumber(_ input: String) -> Int? {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = false
        if let number = numberFormatter.number(from: input)?.intValue {
            return (number > 0 && number <= maxPages) ? number : nil
        }
        return nil
    }
    
}
