//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 4/27/23.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
