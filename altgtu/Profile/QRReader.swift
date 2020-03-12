//
//  QRReader.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 10.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import CodeScanner
import KingfisherSwiftUI
import CoreImage.CIFilterBuiltins

struct QRReader: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @State private var choiseView: Int = 1
    
    let currentUid = Auth.auth().currentUser?.uid
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func getUserInfoBeforeScanQRCode(code: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(code)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
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
    
    var body: some View {
        ZStack {
            if choiseView == 0 {
                ZStack {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "ZvUdV2YKhIfNuzds6UhhV8rqbCu1") { result in
                        switch result {
                        case .success(let code):
                            print("Found code: \(code)")
                            self.getUserInfoBeforeScanQRCode(code: code)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    VStack {
                        Spacer()
                        Image(systemName: "viewfinder")
                            .resizable()
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .padding(.top)
                            .frame(width: 300, height: 300)
                        Spacer()
                        Text("Наведите камеру на QR-код")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                    }
                }
            } else if choiseView == 1 {
                VStack(alignment: .center) {
                    ZStack {
                        Image(uiImage: generatedQRCode(from: currentUid!))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 300, height: 300)
                            .padding(.bottom)
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                        KFImage(URL(string: sessionStore.urlImageProfile))
                            .placeholder {
                                ActivityIndicator(styleSpinner: .medium)
                        }
                        .resizable()
                        .clipShape(Circle())
                        .clipped()
                        .frame(width: 50, height: 50)
                    }
                    Text("Сканируйте этот QR-код")
                    Text("приложением АлтГТУ")
                }
            }
            VStack {
                Picker("", selection: $choiseView) {
                    Text("QR-сканер")
                        .tag(0)
                    Text("Мой QR")
                        .tag(1)
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
            }
        }
    }
}

struct QRReader_Previews: PreviewProvider {
    static var previews: some View {
        QRReader()
    }
}
