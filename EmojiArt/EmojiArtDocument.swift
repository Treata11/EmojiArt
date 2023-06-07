//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 4/27/23.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable, Equatable
{
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    
    static let palette = "👩🏻‍🦰🌹🌖☄️⛄️🌟🪨🐌💀"
    
    @Published private var emojiArt: EmojiArt
    
    private var autosaveCancellable: AnyCancellable?
    // The declaration of this var is to make the code inside init live after the execution
    // So our publisher does not go away after init finishes executing; it stays in the heap.
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink() { emojiArt in
            print("\(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: defaultsKey)
        }
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        get { emojiArt.backgroundURL }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCancellable: AnyCancellable?
     
    func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL {
            fetchImageCancellable?.cancel() // To cancle any outstanding request that we're no longer interested in
            fetchImageCancellable  = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main)    // To draw the image using the main thread
                .replaceError(with: nil)    // assing(to: ,on:) only works if you have Never as Error
                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
