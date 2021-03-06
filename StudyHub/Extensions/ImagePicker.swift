//
//  ImagePicker.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Firebase
import FirebaseStorageSwift
import SPAlert
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @EnvironmentObject var sessionStore: SessionStore
    @Binding var selectedSourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = selectedSourceType
        return imagePicker
    }

    func makeCoordinator() -> ImagePicker.Coordinator {
        Coordinator(self)
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
            let uploadImage = photoRef.putData(imageData!, metadata: nil) { [self] result in
                switch result {
                case .success:
                    photoRef.downloadURL { [self] url, error in
                        guard let downloadURL = url else {
                            return
                        }
                        parent.sessionStore.userData.urlImageProfile = downloadURL.absoluteString
                        let docRef = db.collection("profile").document(currentUser.uid)
                        docRef.updateData(["urlImageProfile": parent.sessionStore.userData.urlImageProfile]) { [self] error in
                            if let error = error {
                                print("Error updating document: \(error)")
                                SPAlert.present(title: "Произошла ошибка!", message: "Повторите попытку через несколько минут.", preset: .error)
                                parent.sessionStore.showBanner = false
                            } else {
                                parent.sessionStore.showBanner = false
                            }
                        }
                    }
                case let .failure(error):
                    print("Error: Image could not upload! \(error)")
                    SPAlert.present(title: "Произошла ошибка!", message: "Повторите попытку через несколько минут.", preset: .error)
                    parent.sessionStore.showBanner = false
                }
            }
            uploadImage.observe(.progress) { [self] snapshot in
                parent.sessionStore.percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            }
        }
    }

    func updateUIViewController(_: UIImagePickerController, context _: UIViewControllerRepresentableContext<ImagePicker>) {}
}
