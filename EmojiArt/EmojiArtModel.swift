//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 10/7/22.
//

import Foundation

struct EmojiArtModel {
    var emojis = [Emoji]()
    var background = Background.blank
    
    struct Emoji: Identifiable, Hashable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        let id: UInt16
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: UInt16) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    init() { }  //returning void representing that former init is for access control and not a free init
    
    private var uniqueEmojiId = 0
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: UInt16(uniqueEmojiId)))
    }
}
