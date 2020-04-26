//
//  UnsplashImagePicker.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 16.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import UnsplashPhotoPicker

struct UnsplashImagePicker: UIViewControllerRepresentable {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    
    let configuration = UnsplashPhotoPickerConfiguration(
        accessKey: "f99d21d6eb682196455dd29b621688aff2d525c7c3a7f95bfcb05d497f38f5dc",
        secretKey: "ccff858162e795c062ce13e9d16a2cf607076d0eb185141e35b14f589b1cd713",
        allowsMultipleSelection: false)
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UnsplashImagePicker>) -> UnsplashPhotoPicker {
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = context.coordinator
        return unsplashPhotoPicker
    }
    
    func makeCoordinator() -> UnsplashImagePicker.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: UnsplashPhotoPickerDelegate {
        
        var parent: UnsplashImagePicker
        
        init(_ parent: UnsplashImagePicker) {
            self.parent = parent
        }
        
        func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            let unsplashImage = photos.first
            let urlsToImage = unsplashImage!.urls[.regular]
            parent.sessionStore.userData.setImageForBackroundProfile = urlsToImage!.absoluteString
            parent.sessionStore.userData.choiseTypeBackroundProfile = true
        }
        
        func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
            
        }
    }
    
    func updateUIViewController(_ uiViewController: UnsplashPhotoPicker, context: UIViewControllerRepresentableContext<UnsplashImagePicker>) {
        
    }
}
