//
//  SecureView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import URLImage

struct SecureView: View {
    
    @EnvironmentObject var session: SessionStore
    @State private var userInputPin: String = ""
    @State private var showAlertPinCode: Bool = false
    @Binding var access: Bool
    
    let imagePlaceholder = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"

    func checkAccess() {
        if userInputPin == session.pinCodeAccess {
            self.userInputPin = ""
            self.access = true
        } else {
            self.userInputPin = ""
            self.access = false
            self.showAlertPinCode = true
        }
    }
        
    var body: some View {
            VStack(alignment: .center) {
                URLImage(URL(string:"\(session.urlImageProfile ?? imagePlaceholder)")!, incremental : false, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress > 0.0 {
                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                            }
                            else {
                                CircleActivityView().stroke(lineWidth: 15.0)
                            }
                        }
                    }.frame(width: 90, height: 90)
                }) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .clipped()
                            .shadow(radius: 10)
                            .frame(width: 90, height: 90)
                }
                Text("Привет, \(session.firstname ?? "студент")!")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .padding(.top)
                Spacer()
                HStack {
                    Image(systemName: userInputPin.count >= 1 ? "largecircle.fill.circle" : "circle")
                    Image(systemName: userInputPin.count >= 2 ? "largecircle.fill.circle" : "circle")
                    Image(systemName: userInputPin.count >= 3 ? "largecircle.fill.circle" : "circle")
                    Image(systemName: userInputPin.count >= 4 ? "largecircle.fill.circle" : "circle")
                }.foregroundColor(.defaultColorApp)
                Spacer()
                KeyPad(userInputPin: $userInputPin)
                CustomButton(
                  label: "Продолжить",
                  action: checkAccess
                ).padding(.top)
                Button (action: {
                    self.session.signOut()
                })
                {
                    Text("Выйти")
                        .bold()
                        .foregroundColor(.red)
                }.padding(.top)
            }
            .padding()
            .alert(isPresented: $showAlertPinCode) {
                Alert(title: Text("Ошибка!"), message: Text("Код неверный."), dismissButton: .default(Text("Ок")))
            }
    }
}
