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
            if changelogStore.сhangelogModel.isEmpty && changelogStore.changelogLoadingFailure == false {
                ActivityIndicator(styleSpinner: .large)
                    .onAppear(perform: changelogStore.loadChangelog)
            } else if changelogStore.сhangelogModel.isEmpty && changelogStore.changelogLoadingFailure == true {
                Text("Нет подключения к интернету!")
                    .fontWeight(.bold)
                    .onAppear(perform: changelogStore.loadChangelog)
            } else {
                Form {
                    ForEach(changelogStore.сhangelogModel.sorted { $0.version > $1.version }, id: \.id) { changelog in
                        Section(header:
                            HStack(alignment: .bottom) {
                                Text(changelog.version)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(self.appVersion == changelog.version ? "Текущая версия" : changelog.dateBuild)
                            }
                        ) {
                            VStack(alignment: .leading) {
                                if !changelog.whatsNew.isEmpty {
                                    VStack(alignment: .leading) {
                                        Text("Новое:")
                                            .bold()
                                            .foregroundColor(.purple)
                                            .padding(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundColor(Color.purple.opacity(0.2))
                                            )
                                            .padding(.bottom, 3)
                                        Text(changelog.whatsNew)
                                            .font(.system(size: 16))
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.vertical, 3)
                                }
                                if !changelog.whatsNew.isEmpty && !changelog.bugFixes.isEmpty {
                                    Divider()
                                }
                                if !changelog.bugFixes.isEmpty {
                                    VStack(alignment: .leading) {
                                        Text("Исправления:")
                                            .bold()
                                            .foregroundColor(.green)
                                            .padding(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .foregroundColor(Color.green.opacity(0.2))
                                            )
                                            .padding(.bottom, 3)
                                        Text(changelog.bugFixes)
                                            .font(.system(size: 16))
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.vertical, 3)
                                }
                            }
                        }
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Что нового?"), displayMode: .inline)
    }
}

class ChangelogStore: ObservableObject {
    
    @Published var сhangelogModel: ChangelogModel = [ChangelogModelElement]()
    @Published var changelogLoadingFailure: Bool = false
    
    static let shared = ChangelogStore()
    
    func loadChangelog() {
        AF.request("https://api.lisindmitriy.me/changelog")
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChangelogModel.self) { response in
                switch response.result {
                case .success( _):
                    guard let сhangelog = response.value else { return }
                    self.сhangelogModel = сhangelog
                case .failure(let error):
                    self.changelogLoadingFailure = true
                    print("Список изменений не загружен: \(error.errorDescription!)")
                }
        }
    }
}

struct ChangelogModelElement: Identifiable, Codable {
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
