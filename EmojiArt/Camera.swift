//
//  Camera.swift
//  EmojiArt
//
//  Created by Treata Norouzi on 1/13/23.
//

import SwiftUI

struct Camera: UIViewControllerRepresentable {
    var handlePickedImage: (UIImage?) -> Void
    
    static var isAvailable: Bool  {
        UIImagePickerController.isSourceTypeAvailable(.camera)
        // MVC's Controller
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // nothing to do here!
        // The View doesn't need to get updates from the
        // UIImage, it's only a picture that is taken once
        // and there's no invalidation and rebuiling of views
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage: (UIImage?) -> Void
        
        init(handlePickedImage: @escaping (UIImage?) -> Void) {
            self.handlePickedImage = handlePickedImage
        }
         
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // InfoKey is either "originalImage" or "editedImage"
            handlePickedImage((info[.originalImage] ?? info[.editedImage]) as? UIImage)
        }
    }
}
