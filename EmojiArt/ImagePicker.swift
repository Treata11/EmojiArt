//
//  ImagePicker.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 8/5/23.
//

import SwiftUI
import UIKit

typealias PickedImageHandler = (UIImage?) -> Void

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var handlePickedImage: PickedImageHandler   // Was possible to store the image in a Binding and pass it to the main View
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(handlePickedImage: handlePickedImage)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // UINavigationControllerDelegate is a protocol that UIImagePickerControllerDelegate has to implement!
        var handlePickedImage: PickedImageHandler
        
        init(handlePickedImage: @escaping PickedImageHandler) {
            // we are grabbing onto handlePickedImage and holding onto it so tis a escaping
            self.handlePickedImage = handlePickedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            handlePickedImage(info[.originalImage] as? UIImage)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
    }
}
