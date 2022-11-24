//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/24/22.
//

import SwiftUI

struct PaletteChooser : View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font { .system(size: emojiFontSize) }
    
    @EnvironmentObject var store: PaletteStore
    
    @State var chosenPaletteIndex = 0
    
    var body: some View {
        HStack {
            paletteControlButton
            body(for: store.palette(at: chosenPaletteIndex))
        }
    }
    
    var paletteControlButton: some View {
        Button {
            chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
    }
    
    func body(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojisView(emojis: palette.emojis)
                .font(emojiFont)
        }
    }
}

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.removingDuplicateCharacters.map {String($0)}, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser ()
    }
}
