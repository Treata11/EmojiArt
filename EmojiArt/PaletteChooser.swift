//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 6/5/23.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                chosenPalette = document.palette(after: chosenPalette)
            }, onDecrement: {
                chosenPalette = document.palette(before: chosenPalette)
            }, label: { EmptyView() })
            Text(document.paletteNames[chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: $chosenPalette)
                        .environmentObject(document)
                        .frame(minWidth: 300, minHeight: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument

    @Binding var chosenPalette: String
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Palette Editor").font(.headline).padding()
            Divider()
            TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                if !began {
                    document.renamePalette(chosenPalette, to: paletteName)
                }
            }).padding()
            TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                if !began {
                    chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                    emojisToAdd = ""
                }
            }).padding()

            Spacer()
        }
        .onAppear { paletteName = document.paletteNames[chosenPalette] ?? "" }
    }
}








struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
