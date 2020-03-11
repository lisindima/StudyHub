//
//  License.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

struct License: View {
    
    @ObservedObject var licenseStore: LicenseStore = LicenseStore.shared
    
    var body: some View {
        VStack {
            if licenseStore.licenseModel.isEmpty {
                ActivityIndicator(styleSpinner: .large)
                    .onAppear(perform: licenseStore.loadLicense)
            } else {
                Form {
                    ForEach(licenseStore.licenseModel.sorted { $0.nameFramework < $1.nameFramework }, id: \.id) { license in
                        NavigationLink(destination: LicenseDetail(nameFramework: license.nameFramework, urlFramework: license.urlFramework, textLicenseFramework: license.textLicenseFramework)) {
                            Text(license.nameFramework)
                        }
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Лицензии"), displayMode: .inline)
    }
}

struct LicenseDetail: View {
    
    var nameFramework: String
    var urlFramework: String
    var textLicenseFramework: String
    
    var body: some View {
        VStack {
            ScrollView {
                Text(textLicenseFramework)
                    .padding()
            }
        }
        .navigationBarTitle(Text(nameFramework), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            UIApplication.shared.open(URL(string: self.urlFramework)!)
        }) {
            Image(systemName: "safari")
                .imageScale(.large)
        })
    }
}

class LicenseStore: ObservableObject {
    
    @Published var licenseModel: LicenseModel = [LicenseModelElement]()
    
    static let shared = LicenseStore()
    
    func loadLicense() {
        AF.request("https://api.lisindmitriy.me/license")
        .validate()
        .responseDecodable(of: LicenseModel.self) { response in
            guard let license = response.value else { return }
            self.licenseModel = license
            print("Лицензии загружены")
        }
    }
}

struct LicenseModelElement: Identifiable, Codable {
    let id: Int
    let nameFramework: String
    let urlFramework: String
    let textLicenseFramework: String
}

typealias LicenseModel = [LicenseModelElement]
