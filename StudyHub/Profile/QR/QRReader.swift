//
//  QRReader.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 10.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import CodeScanner
import CoreImage.CIFilterBuiltins
import Firebase
import KingfisherSwiftUI
import SwiftUI

struct QRReader: View {
    @EnvironmentObject var sessionStore: SessionStore

    @ObservedObject private var qrStore: QRStore = QRStore.shared

    @State private var choiseView: Int = 1
    @State private var showProfileFriends: Bool = false

    let currentUser = Auth.auth().currentUser

    var body: some View {
        ZStack {
            if choiseView == 0 {
                ZStack {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "dLlZ2MYmIZSICzP4lPp1a96rDmy1") { result in
                        switch result {
                        case let .success(code):
                            self.qrStore.getUserInfoBeforeScanQRCode(code: code)
                            self.showProfileFriends = true
                        case let .failure(error):
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
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                    }
                }.bottomSheet(isPresented: $showProfileFriends, height: 250) {
                    ProfileFriends()
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                }
            } else if choiseView == 1 {
                VStack(alignment: .center) {
                    Spacer()
                    ZStack {
                        Image(uiImage: qrStore.generatedQRCode(from: currentUser!.uid))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 300, height: 300)
                            .padding(.bottom)
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                        KFImage(URL(string: sessionStore.userData.urlImageProfile))
                            .placeholder { ProgressView() }
                            .resizable()
                            .clipShape(Circle())
                            .clipped()
                            .frame(width: 50, height: 50)
                    }
                    Spacer()
                    Text("Сканируйте этот QR-код приложением StudyHub")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding(.bottom, 30)
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
