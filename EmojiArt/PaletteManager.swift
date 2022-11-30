//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/30/22.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        List {
            ForEach(store.palettes) { palette in
                VStack(alignment: .leading) {   // .leading is dependent on the language r->l or l->r
                    Text(palette.name)
                    Text(palette.emojis)
                }
            }
        }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .environmentObject(PaletteStore(named: "Preview"))
    }
}
