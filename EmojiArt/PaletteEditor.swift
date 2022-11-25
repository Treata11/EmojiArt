//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/25/22.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    
    var body: some View {
        Form {
            TextField("Name", text: $palette.name)
        }
        .frame(minWidth: 333, minHeight: 539)
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        Text("Fix me!")
//        PaletteEditor()
    }
}
