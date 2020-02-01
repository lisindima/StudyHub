//
//  QRReader.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 10.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import CodeScanner

struct QRReader: View {
    
    @State private var choiseView: Int = 1
    
    var name: String = "dima"
    var emailAddress: String = "lisindima1996@gmail.com"
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
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
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Лисин Дмитрий") { result in
                        switch result {
                        case .success(let code):
                            print("Found code: \(code)")
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
                            .padding(.bottom)
                    }
                }
            } else if choiseView == 1 {
                VStack(alignment: .center) {
                    Image(uiImage: generatedQRCode(from: "\(name)\n\(emailAddress)"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 300, height: 300)
                        .padding(.bottom)
                    Text("Сканируйте этот QR-код")
                    Text("приложением АлтГТУ")
                }.font(.system(.body, design: .rounded))
            }
            VStack {
                Picker("", selection: $choiseView) {
                    Text("QR-сканер").tag(0)
                    Text("Мой QR").tag(1)
                }
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
