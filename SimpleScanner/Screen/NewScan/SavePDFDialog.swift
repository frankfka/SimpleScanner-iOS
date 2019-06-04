//
// Created by Frank Jia on 2019-06-02.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation
import UIKit

class SavePDFDialog: NSObject {

    private static var invalidCharacters: CharacterSet {
        var chars = CharacterSet()
        chars.formUnion(.whitespaces)
        chars.formUnion(.alphanumerics)
        chars.formUnion(.punctuationCharacters)
        chars.formUnion(CharacterSet(charactersIn: "-_"))
        return chars.inverted
    }

    private let onConfirm: FileNameCallback
    private let presentingVC: UIViewController

    // UI
    private var dialog: UIAlertController!
    private var textField: UITextField!
    private var confirmAction: UIAlertAction!

    init(presentingVC: UIViewController, onConfirm: @escaping FileNameCallback) {
        self.presentingVC = presentingVC
        self.onConfirm = onConfirm
        super.init()
        dialog = UIAlertController(title: Text.SavePDFTitle, message: Text.SavePDFDescription, preferredStyle: .alert)
        confirmAction = UIAlertAction(title: Text.SavePDFConfirm, style: .default) { _ in
            guard let fileName = self.textField.text else {
                print("No text in text field")
                return
            }
            self.onConfirm(fileName)
        }
        dialog.addAction(confirmAction)
        dialog.addAction(UIAlertAction(title: Text.SavePDFCancel, style: .cancel))
        dialog.addTextField() { textField in
            self.textField = textField
            textField.delegate = self
            textField.text = DocumentCreationService.getDefaultFileName()
        }
    }

    func display() {
        presentingVC.present(dialog, animated: true)
    }

}

extension SavePDFDialog: UITextFieldDelegate {

    // Disable illegal characters
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Delete pressed
        if string.isEmpty {
            return true
        } else if string.rangeOfCharacter(from: SavePDFDialog.invalidCharacters, options: [.caseInsensitive]) == nil {
            // Replacement doesn't contain illegal characters
            return true
        }
        return false
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        confirmAction.isEnabled = textField.text != nil && !textField.text!.isEmpty
    }

}