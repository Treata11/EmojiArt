//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

extension UTType {
    static var emojiart = UTType(exportedAs: "stanford.cs193p.emojiart")
}

class EmojiArtDocument: ReferenceFileDocument
{
    // MARK: Read&Write
    
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
    typealias Snapshot = Data
    
    static var readableContentTypes = [UTType.emojiart]
    static var writableContentTypes = [UTType.emojiart]
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArtModel(json: data)
            fetchBackgroundDataIfNecessary()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {    // Super important, to check our model wether any values had been changed to make it have effect on our UI.
            if emojiArt.background != oldValue.background {
                fetchBackgroundDataIfNecessary()
            }
        }
    }
    
    init() {
        emojiArt = EmojiArtModel() // Create an empty init with the Model
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    
    // MARK: Background
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = backgroundImageFetchStatus.idle
    
    enum backgroundImageFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    
    private var backgroundImageFetchCancellable: AnyCancellable?
    
    private func fetchBackgroundDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            self.backgroundImageFetchStatus = .fetching
            backgroundImageFetchCancellable?.cancel()   // To cancle any previous thread trying to fetch the UIImage
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url) // Get the session's dataTaskPublisher in this case $projectedValue == Publisher; the var's type is IMP
                .map { (data, urlResponse) in UIImage(data: data) } // Taking the publisher's data as an UIImage and ignoring the urlResponse of publisher's tuple
                .replaceError(with: nil)    // Replace any error with the ```UIImage  = nil```
                .receive(on: DispatchQueue.main)    // .sink "part of the UI" has to happen on the mainQueue
            backgroundImageFetchCancellable = publisher
                .sink { [weak self] image in
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = (image != nil) ? .idle : .failed(url)
                }
 
             
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    
    // MARK: - Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background) {
        return emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int(CGFloat(emojiArt.emojis[index].size) * scale.rounded(.toNearestOrAwayFromZero))
            
        }
    }
    
    // MARK: -Undo
    
    private func undoablyPerform(operation: String,  with undoManager: UndoManager? = nil, doit:() -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.emojiArt = oldEmojiArt
        }
        undoManager?.setActionName(operation)
    }
}


