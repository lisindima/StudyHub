//
//  QRStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 18.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import CoreImage.CIFilterBuiltins
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class QRStore: ObservableObject {
    @Published var profileFriendsModel: ProfileFriendsModel!

    static let shared = QRStore()

    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    func getUserInfoBeforeScanQRCode(code: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(code)
        docRef.getDocument { document, error in
            let result = Result {
                try document?.data(as: ProfileFriendsModel.self)
            }
            switch result {
            case let .success(profileFriendsModel):
                if let profileFriendsModel = profileFriendsModel {
                    self.profileFriendsModel = profileFriendsModel
                } else {
                    print("Document does not exist")
                }
            case let .failure(error):
                print("Error decoding profileFriendsModel: \(error)")
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

struct ProfileFriendsModel: Identifiable, Codable {
    @DocumentID var id: String?
    var firstname: String
    var lastname: String
    var urlImageProfile: String
}
