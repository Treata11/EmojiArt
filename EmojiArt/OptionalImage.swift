//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 5/9/23.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}

