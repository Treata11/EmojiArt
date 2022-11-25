//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/25/22.
//

import SwiftUI

struct PaletteEditor: View {
    @State private var palette: Palette = PaletteStore(named: "test").palette(at: 2)
    
    var body: some View {
        Form {
            TextField("Name", text: $palette.name)
        }
        .frame(minWidth: 333, minHeight: 539)
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor()
    }
}
