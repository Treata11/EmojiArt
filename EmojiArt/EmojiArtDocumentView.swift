//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 51
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            
            pallete
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.brightness(0.39).overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .position(converFromEmojiCoordinates((0,0), in: geometry))
                )
                ForEach(document.emojis) { emoji in
                    Text(emoji.text)
                        .font(.system(size: fontSize(for: emoji)))
                        .position(position(for: emoji, in: geometry))
                }
            }
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil) { providers, location in
                return drop(providers: providers, at: location, in: geometry)
            }
        }
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(EmojiArtModel.Background.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                         size: defaultEmojiFontSize)
                }
            }
        }
        return found
    }
        
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center: CGPoint = geometry.frame(in: .local).center
        let location = CGPoint(
            x: location.x - center.x,
            y: location.y - center.y
        )
        return (Int(location.x), Int(location.y))
    }
    private func converFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center: CGPoint = geometry.frame(in: .local).center
         
        return CGPoint(
            x: center.x + CGFloat(location.x),
            y: center.y + CGFloat(location.y)
        )
    }
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        converFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    let testEmojis = "🍎🫒🍕🥗🍫🥎🛹🛼🚵🏻🚣🏼🏵🎭🎮🚚🚲🛸🚁🛰🏝🚥🌆🖥🗜💽🕰🔌🔨🧨"
    
    var pallete: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
}

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map {String($0)}, id: \.self ) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
