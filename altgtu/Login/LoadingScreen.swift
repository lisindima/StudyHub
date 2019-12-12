//
//  LoadingScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 10.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Lottie

struct LoadingScreen: View {
    var body: some View {
        VStack {
            Image("altgtu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, alignment: .center)
                .shadow(radius: 10)
            LottieView(filename: "27-loading")
                .frame(width: 200, height: 200)
        }
    }
}

struct LoadingLogic: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sessionChat: SessionChat
    
    func getData() {
        session.getDataFromDatabaseListen()
        sessionChat.getDataFromDatabaseListenChat()
        sessionChat.loadMsgsList()
    }
    
    var body: some View {
        ZStack {
            if session.lastname == nil {
                LoadingScreen()
            } else {
                Tabbed()
            }
        }.onAppear(perform: getData)
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
