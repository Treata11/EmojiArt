//
//  PalletteChooser.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/24/22.
//

import SwiftUI

struct PalletteChooser : View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font { .system(size: emojiFontSize) }
    
    var body: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(emojiFont)
    }
    
        let testEmojis = "🍎🫒🍕🥗🍫🥎🛹🛼🚵🏻🚣🏼🏵🎭🎮🚚🚲🛸🚁🛰🏝🚥🌆🖥🗜💽🕰🔌🔨🧨"
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
        PalletteChooser ()
    }
}
