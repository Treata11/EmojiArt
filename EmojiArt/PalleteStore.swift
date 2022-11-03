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
        UserDefaults.standard.set(palletes.map { [$0.name,$0.emojis,String($0.id)] }, forKey: userDefaultsKey)
    } // map is being used to omit the array[any] type, this API is from the old world and is being compatible with swift by this trick
    
    private func restoreFromUserDefaults() {
        if let palleteAsPropertyList = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String]] {
            for palletesAsArray in palletesAsPropertyList {
                if palletesAsArray.count == 3, let id = Int(palletesAsArray[2]), !palletes.contains(where: { $0.id == id }) {
                    let pallete = Pallete(name: palletesAsArray[0], emojis: palletesAsArray[1], id: id)
                    palletes.append(pallete)
                }
            }
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
