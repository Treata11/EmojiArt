//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 4/27/23.
//

import SwiftUI

@main
struct EmojiArtApp: App {
///    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // returns an [URL], because on different platforms the .urls can have  multiple Masks
    let store = EmojiArtDocument(url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! )
//    let store = EmojiArtDocumentStore(named: "Emoji Art")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
//            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
