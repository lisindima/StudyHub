//
//  Changelog.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 20.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

struct Changelog: View {
    
    @ObservedObject var changelogStore: ChangelogStore = ChangelogStore.shared
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var body: some View {
        VStack {
            if changelogStore.сhangelogModel.isEmpty {
                ActivityIndicator(styleSpinner: .large)
                    .onAppear(perform: changelogStore.loadChangelog)
            } else {
                Form {
                    ForEach(changelogStore.сhangelogModel.sorted { $0.version > $1.version }, id: \.id) { changelog in
                        Section(header:
                            HStack(alignment: .bottom) {
                                if self.appVersion == changelog.version {
                                    Text(changelog.version)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("Текущая версия")
                                } else {
                                    Text(changelog.version)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(changelog.dateBuild)
                                }
                            }.padding(.top)
                        ) {
                            VStack(alignment: .leading) {
                                if !changelog.whatsNew.isEmpty {
                                    Text("Что нового:")
                                        .bold()
                                        .padding(.bottom, 5)
                                    Text(changelog.whatsNew)
                                        .foregroundColor(.secondary)
                                }
                                if !changelog.bugFixes.isEmpty {
                                    Text("Исправленные ошибки:")
                                        .bold()
                                        .padding(.bottom, 5)
                                        .padding(.top)
                                    Text(changelog.bugFixes)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Список изменений"), displayMode: .inline)
    }
}

class ChangelogStore: ObservableObject {
    
    @Published var сhangelogModel: ChangelogModel = [ChangelogModelElement]()
    
    static let shared = ChangelogStore()
    
    func loadChangelog() {
        AF.request("https://altstuapi.herokuapp.com/changelog")
        .validate()
        .responseDecodable(of: ChangelogModel.self) { (response) in
            guard let сhangelog = response.value else { return }
            self.сhangelogModel = сhangelog
            print("Лицензии загружены")
        }
    }
}

struct ChangelogModelElement: Codable, Hashable, Identifiable {
    let id: Int
    let version: String
    let dateBuild: String
    let whatsNew: String
    let bugFixes: String
}

typealias ChangelogModel = [ChangelogModelElement]

struct Changelog_Previews: PreviewProvider {
    static var previews: some View {
        Changelog()
    }
}
