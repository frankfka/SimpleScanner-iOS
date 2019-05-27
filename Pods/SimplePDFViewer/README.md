# SimplePDFViewer
An easy to use UIViewController that renders local & remote PDF's with basic customization and functionality.

[![Version](https://img.shields.io/cocoapods/v/SimplePDFViewer.svg?style=flat)](https://cocoapods.org/pods/SimplePDFViewer)
[![License](https://img.shields.io/cocoapods/l/SimplePDFViewer.svg?style=flat)](https://cocoapods.org/pods/SimplePDFViewer)
[![Platform](https://img.shields.io/cocoapods/p/SimplePDFViewer.svg?style=flat)](https://cocoapods.org/pods/SimplePDFViewer)

## Introduction
SimplePDFViewer lets you show PDF documents when very little customization/advanced functionality is required. The library is built on top of Apple's [PDFKit](https://developer.apple.com/documentation/pdfkit). 

<div align="center">
<img src="https://raw.githubusercontent.com/frankfka/SimplePDFViewer/master/Images/StandardRender.png" alt="Standard VC" width="270" height="480" />
<img src="https://raw.githubusercontent.com/frankfka/SimplePDFViewer/master/Images/Error.png" alt="Error VC" width="270" height="480" />
<img src="https://raw.githubusercontent.com/frankfka/SimplePDFViewer/master/Images/JumpToPage.png" alt="Dialog" width="270" height="480" />
</div><br/>

Features include:
- Initialization from local/remote URL, raw data, or `PDFDocument`
- Jump-to-page dialog
- Page tracking
- Export file using standard iOS sharesheet
- Basic customization (tint, error message, VC title, etc.)

The library was created to provide basic PDF functionality for another application. It will be maintained by myself, [Frank Jia](http://jiafrank.com/). If there is demand, I'm open to adding functionality and additional customization. Don't hesistate to reach out at `contact@jiafrank.com`.

## Usage

SimplePDFViewer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SimplePDFViewer'
```
To use SimplePDFViewer, import `SimplePDFViewer`. You can then instantiate an instance of the VC like so:
```
let pdfVC = SimplePDFViewController(urlString: ViewController.TEST_PDF_URL)
pdfVC.viewTitle = "Test View Title" // Custom view title on top bar
pdfVC.tint = .red // Tint applies to all views in the VC
pdfVC.exportPDFName = "TestExportPDF" // File name for sharing, default is "Document"
pdfVC.errorMessage = "Uh oh!" // Custom error message if PDF fails to load
```
There are also constructors for the VC from a URL, PDFDocument, or raw Data. You can then present the VC using:
```
present(pdfVC, animated: true, completion: nil) // Presents modally
navigationController?.pushViewController(pdfVC, animated: true) // Pushes onto navigation stack
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## License

SimplePDFViewer is available under the MIT license. See the LICENSE file for more info.
