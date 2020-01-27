//
//  LoadingScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 10.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LoadingLogic: View {
    
    @EnvironmentObject var session: SessionStore
    
    @State private var access: Bool = false
    
    func getData() {
        session.getDataFromDatabaseListen()
    }
    
    var body: some View {
        ZStack {
            if session.lastname != nil && session.boolCodeAccess == false {
                Tabbed()
            } else if session.lastname != nil && session.boolCodeAccess == true && access == true {
                Tabbed()
            } else if session.lastname != nil && session.boolCodeAccess == true && access == false {
                SecureView(access: $access)
            } else {
                ActivityIndicator(styleSpinner: .large)
            }
        }.onAppear(perform: getData)
    }
}
