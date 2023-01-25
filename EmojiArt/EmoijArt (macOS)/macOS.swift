//
//  macOS.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 1/25/23.
//

import SwiftUI

typealias UIImage = NSImage

typealias PaletteManager = EmptyView

///struct OptionalImage: View {
///var uiImage: UIImage?

///var body: some View {
///    if uiImage != nil {
///        Image(uiImage: uiImage!)
///     }
///}
extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
// the extension above is created to initialize Image constructor
// with NSImage for the macOS. note that:
/// typealias UIImage = NSImage

/// Abstraction
extension UIImage {
    var imageData: Data? { tiffRepresentation }
}

/// Abstraction
struct Pasteboard {
    static var imageData: Data? {
        NSPasteboard.general.data(forType: .tiff) ?? NSPasteboard.general.data(forType: .png)
    }
    static var imageURL: URL? {
        (NSURL(from: NSPasteboard.general) as  URL?)?.imageURL
    }
}

// It is good habit to have ViewModifiers to have different
// behaviour OS specific istead of using #if os(...) :)
extension View {
    func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        self    // do nothing
    }
    
    /// Abstraction
    func paletteControlButtonStyle() -> some View {
        self.buttonStyle(PlainButtonStyle()).foregroundColor(.accentColor).padding(.vertical)
    }
    
    func popoverPadding() -> some View {
        self.padding(.horizontal)
    }
}

struct CantDoItPhotoPicker: View {
    var handlePickedImage: (UIImage?) -> Void
    
    static let isAvailable = false
    
    var body: some View {
        EmptyView()
    }
}

typealias Camera = CantDoItPhotoPicker
typealias PhotoLibrary = CantDoItPhotoPicker

