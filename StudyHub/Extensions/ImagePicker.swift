//
//  ImagePicker.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

struct ImagePicker: UIViewControllerRepresentable {
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
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
            photoPicker.dismiss(animated: true)
            let imageProfile = info[.originalImage] as! UIImage
            let currentUser = Auth.auth().currentUser!
            let db = Firestore.firestore()
            let storage = Storage.storage()
            let storageRef = storage.reference()
            var photoRef = storageRef.child("photoProfile/\(currentUser.uid).jpeg")
            let storagePath = "gs://altgtu-46659.appspot.com/photoProfile/\(currentUser.uid).jpeg"
            photoRef = storage.reference(forURL: storagePath)
            let data = imageProfile.jpegData(compressionQuality: 1)
            if data == nil {
                return
            } else {
                parent.sessionStore.showBanner = true
                let uploadImageTask = photoRef.putData(data!, metadata: nil) { metadata, error in
                    photoRef.downloadURL { url, error in
                        guard let downloadURL = url else {
                            return
                        }
                        self.parent.sessionStore.urlImageProfile = downloadURL.absoluteString
                        let docRef = db.collection("profile").document(currentUser.uid)
                        docRef.updateData([
                            "urlImageProfile": self.parent.sessionStore.urlImageProfile as String
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                                self.parent.sessionStore.showBanner = false
                            } else {
                                db.collection("profile").document(currentUser.uid)
                                    .addSnapshotListener { documentSnapshot, error in
                                        if let document = documentSnapshot {
                                            self.parent.sessionStore.urlImageProfile = document.get("urlImageProfile") as? String
                                            self.parent.sessionStore.showBanner = false
                                        } else if error != nil {
                                            print((error?.localizedDescription)!)
                                            self.parent.sessionStore.showBanner = false
                                        }
                                }
                                self.parent.sessionStore.showBanner = false
                            }
                        }
                    }
                }
                uploadImageTask.observe(.progress) { snapshot in
                    self.parent.sessionStore.percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                }
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
