//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import SwiftUI
import Combine


class EmojiArtDocument: ObservableObject {
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {    // Super important, to check our model wether any values had been changed to make it have effect on our UI.
            scheduleAutosave()
            if emojiArt.background != oldValue.background {
                fetchBackgroundDataIfNecessary()
            }
        }
    }
    
    private var autosaveTimer: Timer?
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
            self.autosave() // [weak self] is not used, we want self to be held on memory even if the app is closed, otherwise saving won't happen
        }
    }
    
    private struct Autosave { // Constants struct, usded for staticts
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first // .first is used on the behalf of the fact thtat only one folder is used for directory in iOS,
            return documentDirectory?.appendingPathComponent(filename)
        }
            static let coalescingInterval = 6.0
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisfunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try emojiArt.json()
            print("\(thisfunction) JSON = \(String(data: data, encoding: .utf8) ?? "nil")")
            try? data.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisfunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
        } catch let error {
            print("\(thisfunction) error = \(error)")
        }
    }
    
    init() {
        if let url = Autosave.url, let AutosavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = AutosavedEmojiArt
            fetchBackgroundDataIfNecessary()
        } else {
            emojiArt = EmojiArtModel()
        }
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
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
            let publisher = session.dataTaskPublisher(for: url)
                .map { (data, urlResponse) in UIImage(data: data) } // Taking the publisher's data as an UIImage and ignoring the urlResponse of publisher's tuple
                .replaceError(with: nil)    // Replace any error with the ```UIImage  = nil```
                .receive(on: DispatchQueue.main)    // .sink "part of the UI" has to happen on the mainQueue
            
            backgroundImageFetchCancellable = publisher
//                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
                .sink { [weak self] image in
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = (image != nil) ? .idle : .failed(url)
                }
            
            
            
//            DispatchQueue.global(qos: .userInitiated).async {
//                let imageData = try? Data(contentsOf: url)  //Data should be error handled; the call for the url can easily time-out so we have to decide what is going to happen if the 'try' fails
//                DispatchQueue.main.async { [weak self] in   // [weak self]: weak is a method to tell the compiler to create an optional self within our closure. Closures are refrence types and when we refer to the self, self is going to last in the memory even if we remove the document, because the closure had refrenced 'self' and RefrenceCount isn't going to remove self from the heap. We have to specify the refrence as weak for the complier to not to count it Meaning that when we remove the document (url), it won't remain in the heap
//                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) { // art of asynchronous programming language: what if user is impatient and drags a new url from the web before the initial image is fully downloaded: We have to ignore the first try, or it will apear after downloaded and blocks the user's intents.
//                        self?.backgroundImageFetchStatus = .idle
//                        if imageData != nil {
//                            self?.backgroundImage = UIImage(data: imageData!)
//                        }
//                        if self?.background.imageData == nil {
//                            self?.backgroundImageFetchStatus = .failed(url)
//                        }
//                    }
//                }
//            }
             
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
}


