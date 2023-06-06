//
//  Spinning.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 6/3/23.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .onAppear() { isVisible = true }
            .rotationEffect(Angle.degrees(360))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isVisible)
    }
    
}

extension View {
    func spinning() -> some View {
        self.modifier(Spinning())
    }
}
