//
//  ImagePicker.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorageSwift

struct ImagePicker: UIViewControllerRepresentable {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @Binding var selectedSourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = selectedSourceType
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
            photoPicker.dismiss(animated: true)
            let currentUser = Auth.auth().currentUser!
            let db = Firestore.firestore()
            let imageProfile = info[.originalImage] as! UIImage
            let imageData = imageProfile.jpegData(compressionQuality: 1)
            parent.sessionStore.showBanner = true
            let photoRef = Storage.storage().reference(forURL: "gs://altgtu-46659.appspot.com/photoProfile/\(currentUser.uid).jpeg")
            let uploadImage = photoRef.putData(imageData!, metadata: nil) { result in
                switch result {
                case .success(_):
                    photoRef.downloadURL { url, error in
                        guard let downloadURL = url else {
                            return
                        }
                        self.parent.sessionStore.userData.urlImageProfile = downloadURL.absoluteString
                        let docRef = db.collection("profile").document(currentUser.uid)
                        docRef.updateData(["urlImageProfile": self.parent.sessionStore.userData.urlImageProfile]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                                self.parent.sessionStore.showBanner = false
                            } else {
                                self.parent.sessionStore.showBanner = false
                            }
                        }
                    }
                case .failure(let error):
                    print("Error: Image could not upload! \(error)")
                    self.parent.sessionStore.showBanner = false
                }
            }
            uploadImage.observe(.progress) { snapshot in
                self.parent.sessionStore.percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
