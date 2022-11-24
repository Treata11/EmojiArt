//
//  PalleteStore.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/3/22.
//

import SwiftUI

struct Pallete: Identifiable, Codable {
    var name: String
    var emojis: String
    var id: Int
    
    fileprivate init(name: String, emojis: String, id: Int) { // the only way to add palletes to PalleteStore is by insertPallete
        self.name = name
        self.emojis = emojis
        self.id = id
    }
}

class PalleteStore {
    let name: String
    
    @Published var palletes = [Pallete]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "PalleteStore" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(palletes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
        let decodedPalletes = try? JSONDecoder().decode([Pallete].self, from: jsonData) {
            palletes = decodedPalletes
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if palletes.isEmpty {
            print("using built-in palletes")
            // load-up with some default values
        } else {
            print("successfully loaded palletes from UserDefaults: \(palletes)")
        }
    }
    
    // MARK: - Intent
    
    func pallete(at index: Int) -> Pallete {
        let safeIndex = min(max(index, 0), palletes.count - 1)
        return palletes[safeIndex]
    }
    
    @discardableResult
    func removePallete(at index: Int) -> Int {
        if palletes.count > 1, palletes.indices.contains(index) {
            palletes.remove(at: index)
        }
        return index % palletes.count
    }
    
    func insertPallete(named name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (palletes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let pallete = Pallete(name: name, emojis: emojis ?? "", id: unique)
        let safeIndex = min(max(index, 0), palletes.count)
        palletes.insert(pallete, at: safeIndex)
    }
}