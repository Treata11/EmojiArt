//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var document = EmojiArtDocument()  // MVVMs have to be marked with @StateObject on the top lvl of the app
    @StateObject var paletteStore = PaletteStore(named: "Default")  // Essentially to mark any source of truth with @State
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
                .environmentObject(paletteStore)  // Injecting paletteStore Model at top level, this makes it be injected to EmojiArtDocumentView and all Views using it and their bodies
        }
    }
}


// Failed to register bundl e identifier: You are not allowed to register an app identifier with the "com.apple." prefix. Change your bundle identifier and try again.


