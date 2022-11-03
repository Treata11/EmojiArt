//
//  PalleteStore.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/3/22.
//

import SwiftUI

struct Pallete: Identifiable {
    var name: String
    var emojis: String
    var id: Int
}

class PalleteStore {
    let name: String
    
    @Published var pallete = [Pallete]()
    
    init(named name: String) {
        self.name = name
