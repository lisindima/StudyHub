//
//  QRStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import CoreImage.CIFilterBuiltins

class QRStore: ObservableObject {
    
    @Published var profileFriendsModel: Array = [ProfileFriendsModel]()
    
    static let shared = QRStore()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func getUserInfoBeforeScanQRCode(code: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(code)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let id = document.documentID
                let lastname = document.get("lastname") as! String
                let firstname = document.get("firstname") as! String
                let urlImageProfile = document.get("urlImageProfile") as! String
                self.profileFriendsModel.append(ProfileFriendsModel(id: id, firstname: firstname, lastname: lastname, urlImageProfile: urlImageProfile))
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func generatedQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct ProfileFriendsModel: Identifiable {
    let id: String
    let firstname: String
    let lastname: String
    let urlImageProfile: String
}
