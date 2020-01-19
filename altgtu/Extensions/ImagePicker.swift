//
//  ImagePicker.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var imageFromPicker: UIImage
    @Binding var selectedSourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = selectedSourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ photoPicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.imageFromPicker = info[.originalImage] as! UIImage
            photoPicker.dismiss(animated: true)
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
