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
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor()
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/600.0/*@END_MENU_TOKEN@*/))
    }
}
