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
    @State private var string = "0"
    let urltest = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
    var body: some View {
        VStack(alignment: .center) {
            URLImage(URL(string:"\(urltest)")!, incremental : false, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: {
                ProgressView($0) { progress in
                    ZStack {
                        if progress > 0.0 {
                            CircleProgressView(progress).stroke(lineWidth: 8.0)
                                .frame(width: 50, height: 50)
                        }
                        else {
                            CircleActivityView().stroke(lineWidth: 50.0)
                                .frame(width: 50, height: 50)
                        }
                    }
                }.frame(width: 150, height: 150)
            }) { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .clipped()
                        .shadow(radius: 10)
                        .frame(width: 150, height: 150)
            }
            Text("Здравствуйте, Дмитрий!")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top)
            Spacer()
            HStack {
                Spacer()
                Text(string)
                Spacer()
            }.padding([.leading, .trailing])
            Divider()
            KeyPad(string: $string)
        }
        .font(.largeTitle)
        .padding()
    }
}

struct SecureView_Previews: PreviewProvider {
    static var previews: some View {
        SecureView()
    }
}
