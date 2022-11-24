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
    
    var body: some View {
        let palette = store.palette(at: 0)
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
