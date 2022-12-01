//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/30/22.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    @Environment(\.colorScheme) var colorScheme
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name).font(editMode == .active ? .largeTitle : .subheadline)
                            Text(palette.emojis)
                        }
                    }
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                EditButton()    // Toggles the value of editMode in its environment
            }
            .environment(\.editMode, $editMode) // A binding EnvironmentValue
        }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .previewDevice("iP hone 14")
            .environmentObject(PaletteStore(named: "Preview"))
    }
}
