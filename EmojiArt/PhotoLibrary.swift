//
//  PhotoLibrary.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 1/14/23.
//

import SwiftUI
import PhotosUI

struct photoLibrary: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PHPickerViewController {
        <#code#>
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        <#code#>
    }
    
    typealias UIViewControllerType = PHPickerViewController
    
    var handlePickedImage: (UIImage?) -> Void
    
    var isAvailable: Bool {
        return true
    }
}
