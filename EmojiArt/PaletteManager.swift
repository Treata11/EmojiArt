//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 11/30/22.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name).font(editMode == .active ? .title2 : .subheadline)
                            Text(palette.emojis)
                        }
                        .gesture(editMode == .active ? tap : nil)
                    }
                }
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    EditButton()    // Toggles the value of editMode in its environment
                }
                ToolbarItem(placement: .cancellationAction) {
                    if presentationMode.wrappedValue.isPresented,
                        UIDevice.current.userInterfaceIdiom != .pad {   // Not to be shown on iPads 
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode) // A binding EnvironmentValue
        }
    }
    
    // MARK: - Assignment

    var tap: some Gesture {
        TapGesture().onEnded {
            // Feature to bring up a UI to edit themes
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
