//
//  License.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 28.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Alamofire
import Combine
import SwiftUI

struct License: View {
    @ObservedObject private var licenseStore: LicenseStore = LicenseStore.shared

    var body: some View {
        VStack {
            if licenseStore.licenseModel.isEmpty && !licenseStore.licenseLoadingFailure {
                ProgressView()
                    .onAppear(perform: licenseStore.loadLicense)
            } else if licenseStore.licenseModel.isEmpty && licenseStore.licenseLoadingFailure {
                Text("Нет подключения к интернету!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
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
        .navigationBarTitle("Лицензии", displayMode: .inline)
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
                    .font(.system(size: 14, design: .monospaced))
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
    @Published var licenseModel: [LicenseModel] = [LicenseModel]()
    @Published var licenseLoadingFailure: Bool = false

    static let shared = LicenseStore()

    func loadLicense() {
        AF.request("https://api.lisindmitriy.me/license")
            .validate()
            .responseDecodable(of: [LicenseModel].self) { response in
                switch response.result {
                case .success:
                    guard let license = response.value else { return }
                    self.licenseModel = license
                case let .failure(error):
                    self.licenseLoadingFailure = true
                    print("Список лицензий не загружен: \(error.errorDescription!)")
                }
            }
    }
}

struct LicenseModel: Identifiable, Codable {
    let id: Int
    let nameFramework: String
    let urlFramework: String
    let textLicenseFramework: String
}
