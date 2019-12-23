//
//  LoadingScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 10.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Image("altgtu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, alignment: .center)
                .shadow(radius: 10)
            Spacer()
            ActivityIndicator()
                .padding(.bottom, 35)
            Text("Загрузка данных...")
                .padding(.bottom)
        }
    }
}

struct LoadingLogic: View {

    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sessionChat: SessionChat
    @State private var access: Bool = false
    
    func getData() {
        session.getDataFromDatabaseListen()
        sessionChat.getDataFromDatabaseListenChat()
        sessionChat.loadMsgsList()
    }
    
    var body: some View {
        ZStack {
            if session.lastname != nil && session.boolCodeAccess == false {
                Tabbed()
            } else if session.lastname != nil && session.boolCodeAccess == true && access == false {
                SecureView(access: $access)
            } else if session.lastname != nil && session.boolCodeAccess == true && access == true {
                Tabbed()
            } else {
                LoadingScreen()
            }
        }.onAppear(perform: getData)
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
