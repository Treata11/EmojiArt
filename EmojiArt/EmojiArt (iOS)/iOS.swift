//
//  iOS.swift
//  EmojiArt (iOS)
//
//  Created by Treata Norouzi on 1/25/23.
//

import SwiftUI
/// Abstraction
extension UIImage {
    var imageData: Data? { jpegData(compressionQuality: 1.0) }
}

/// Abstraction
struct Pasteboard {
    static var imageData: Data? {
        UIPasteboard.general.image?.imageData
    }
    static var imageURL: URL? {
        UIPasteboard.general.url?.imageURL 
    }
}

// It is nice to have modifing functions be optionals
//so we pass nil to them to not to do anything at the very beginning,
//we marked the dismiss function arguement optional,
//so no process or very little took place if the our arguement is nil
// If the optional dismiss in unwrappable, we compute the closure
 
extension View {
    /// Abstraction
    func paletteControlButtonStyle() -> some View {
        self    // do nothing (default style)
    }
    
    func popoverPadding() -> some View {
        self
    }
    
    @ViewBuilder
    func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            NavigationView {
                self
                navigationBarTitleDisplayMode(.inline)
                    .dismissable(dismiss)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            self
        }
    }
    
    @ViewBuilder
    func dismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            NavigationView {
                self.toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { dismiss() }
                    }
                }
                navigationBarTitleDisplayMode(.inline)
            }
        } else {
            self
        }
    }
}
