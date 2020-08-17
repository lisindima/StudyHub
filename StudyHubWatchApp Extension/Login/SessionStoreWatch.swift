//
//  SessionStoreWatch.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 20.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Combine
import SwiftUI

class SessionStoreWatch: ObservableObject {
    @Published var signInSuccess: Bool = false
    static let shared = SessionStoreWatch()
}
