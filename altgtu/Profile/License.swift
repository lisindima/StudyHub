//
//  License.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct License: View {
    var body: some View {
        Form {
            NavigationLink(destination: LottieLicense()) {
            Text("url-image")
            }
            NavigationLink(destination: LottieLicense()) {
            Text("lottie-ios")
            }
            .navigationBarTitle(Text("Лицензии"), displayMode: .inline)
        }
    }
}

struct URLImageLicense: View {
    var body: some View {
        VStack {
            Text("")
        }
        .navigationBarTitle(Text("url-image"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
                UIApplication.shared.open(URL(string: "https://github.com/dmytro-anokhin/url-image")!)
            })
            {
                Image(systemName: "safari")
                    .imageScale(.large)
        })
    }
}

struct LottieLicense: View {
    var body: some View {
        VStack {
            Text("")
        }
        .navigationBarTitle(Text("lottie-ios"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
                UIApplication.shared.open(URL(string: "https://github.com/airbnb/lottie-ios")!)
            })
            {
                Image(systemName: "safari")
                    .imageScale(.large)
        })
    }
}

struct License_Previews: PreviewProvider {
    static var previews: some View {
        License()
    }
}
