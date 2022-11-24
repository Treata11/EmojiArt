//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    let paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
                .environmentObject(paletteStore)  // Injecting paletteStore Model at top level, this makes it be injected to EmojiArtDocumentView and all Views using it and their bodies
        }
    }
}


// Failed to register bundl e identifier: You are not allowed to register an app identifier with the "com.apple." prefix. Change your bundle identifier and try again.


