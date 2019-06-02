//
// Created by Frank Jia on 2019-06-02.
// Copyright (c) 2019 Frank Jia. All rights reserved.
//

import Foundation

// Represents a reference to a temporary image file
public final class TempFile {

    public let url: URL

    public init(extension ext: String) {
        url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(ext)
    }

    deinit {
        print("Deinitializing \(self.url.path)")
        DispatchQueue.global(qos: .utility).async { [contentURL = self.url] in
            try? FileManager.default.removeItem(at: contentURL)
        }
    }
}

// Represents a reference to a PDF file
public final class PDFFile {

    public let url: URL

    public init(fileName: String) {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url = docDirectory.appendingPathComponent(fileName).appendingPathExtension("pdf")
    }

}