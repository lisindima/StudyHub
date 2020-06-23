//
//  Changelog.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 20.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

struct Changelog: View {
    
    @ObservedObject private var changelogStore: ChangelogStore = ChangelogStore.shared
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var body: some View {
        VStack {
            if changelogStore.сhangelogModel.isEmpty && !changelogStore.changelogLoadingFailure {
                ProgressView()
                    .onAppear(perform: changelogStore.loadChangelog)
            } else if changelogStore.сhangelogModel.isEmpty && changelogStore.changelogLoadingFailure {
                Text("Нет подключения к интернету!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .onAppear(perform: changelogStore.loadChangelog)
            } else {
                Form {
                    ForEach(changelogStore.сhangelogModel.sorted { $0.version > $1.version }, id: \.id) { changelog in
                        Section(header:
                            HStack(alignment: .bottom) {
                                Text(changelog.version)
                                    .font(.title)
                                    .fontWeight(.bold)
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
        .navigationBarTitle("Что нового?", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            UIApplication.shared.open(URL(string: "https://studyhub.lisindmitriy.me/changelog/")!)
        }) {
            Image(systemName: "safari")
                .imageScale(.large)
        })
    }
}

class ChangelogStore: ObservableObject {
    
    @Published var сhangelogModel: [ChangelogModel] = [ChangelogModel]()
    @Published var changelogLoadingFailure: Bool = false
    
    static let shared = ChangelogStore()
    
    func loadChangelog() {
        AF.request("https://api.lisindmitriy.me/changelog")
            .validate()
            .responseDecodable(of: [ChangelogModel].self) { response in
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

struct ChangelogModel: Identifiable, Codable {
    let id: Int
    let version: String
    let dateBuild: String
    let whatsNew: String
    let bugFixes: String
}
