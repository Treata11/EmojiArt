//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 4/27/23.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let store = EmojiArtDocumentStore(named: "Emoji Art")
//    store.addDocument(named: "Hello, World!")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
//            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
