//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Environment(\.editMode) private var editMode
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0,0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size).exclusively(before: unselectAllEmojisGesture()))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Group {
                            if selectedEmojis.contains(emoji) {
                                if #available(iOS 15.0, *) {
                                    Group {
                                        RotationallyAnimatedText(text: emoji.text, angle: rotationAngle)
//                                        AnimatableText(angle: rotationAngle, name: "", text: emoji.text, fontScale: defaultEmojiFontSize)
                                            .overlay() {
                                                AnimatedActionButton(title: nil, systemImage: "minus.circle.fill") {
                                                    withAnimation { // must be a transition
                                                        selectedEmojisID.remove(emoji.id)
                                                        document.removeEmoji(emoji)
                                                    }
                                                }
                                                .offset(x: -emojiZoomScale(emoji) * 50, y: -emojiZoomScale(emoji) * 50)
                                                .scaleEffect(emojiZoomScale(emoji) / 2.5)
                                                .foregroundColor(.accentColor)
                                                .opacity(0.7)
                                            }
                                    }
                                    .padding()
                                    .onAppear() {
                                        withAnimation(.linear(duration: 0.25).repeatForever(autoreverses: true)) {
                                            rotationAngle -= .degrees(5)
                                            }
                                        }
                                } else {
                                    /// Fallback on earlier versions:
                                    // If the device isn't updated with iOS15
                                    // There will be a button provided to delete
                                    // selected emojis, and would be the only
                                    // way to actually delete them.
                                }
                            } else {
                                Text(emoji.text)
                            }
                        }
//                        .gesture(editMode?.wrappedValue == .active ? zoomGesture : nil) // for selection
                        .gesture(selectedEmojisID.contains(emoji.id) ? nil : selectEmojiGesture(for: emoji))
                        .font(.system(size: fontSize(for: emoji)))
                        .scaleEffect(emojiZoomScale(emoji))
                        .position(position(for: emoji, in: geometry))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(panGesture().simultaneously(with: zoomGesture()))
        }
    }
    
    // MARK: - Drag and Drop
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
                    )
                }
            }
        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    // MARK: - Zooming
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func emojiZoomScale(_ emoji: EmojiArtModel.Emoji) -> CGFloat {
        selectedEmojis.isEmpty ? zoomScale : selectedEmojis.contains(emoji) ? zoomScale : steadyStateZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                if selectedEmojis.hasAnyValue {
                    for emoji in selectedEmojis {
                        document.scaleEmoji(emoji, by: gestureScaleAtEnd)
                    }
                } else {
                    steadyStateZoomScale *= gestureScaleAtEnd
                }
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Select/Deselect/Unselect Emojis
        // A5 a set for a selection of emojis
    @State private var selectedEmojisID = Set<EmojiArtModel.Emoji.ID>()
    @State private var rotationAngle: Angle = .degrees(0)
        
        private var selectedEmojis: Set<EmojiArtModel.Emoji> {
            var selectedEmojis = Set<EmojiArtModel.Emoji>()
            for index in selectedEmojisID {
                selectedEmojis.insert(document.emojis.first(where: { $0.id == index })!)
            }
            return selectedEmojis
        }
        
        private func selectEmojiGesture(for emoji: EmojiArtModel.Emoji) -> some Gesture {
            // bogus!
            // use .updating to check wether isLongPressGestureActive or not
            LongPressGesture(minimumDuration: 0.3)
                .onEnded { _ in
                    editMode?.wrappedValue = .active
                    print("\(emoji.id) was added to \(selectedEmojisID)")
                    withAnimation() {
                        selectedEmojisID.insert(emoji.id)
                        rotationAngle = .degrees(5)
                    }
                }
        }
        
//        private func deselectEmojiGesture(for emoji: EmojiArtModel.Emoji) -> some Gesture {
//            return TapGesture(count: 1)
//                .onEnded {
//                    withAnimation {
//                        selectedEmojisID.toggleMatching(emoji.id)
//                        print("\(emoji.id) was removed from \(selectedEmojisID)")
//                    }
//                }
//        }
        
        private func unselectAllEmojisGesture() -> some Gesture {
            TapGesture(count: 1)
                .onEnded {
                    editMode?.wrappedValue = .inactive
                    withAnimation {
                        selectedEmojisID = []
                        //                    selectedEmojis.removeAll()
                    }
                }
        }
    
    // MARK: - Panning
    
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }

    // MARK: - Palette
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
}

struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
