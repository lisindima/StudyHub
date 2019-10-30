//
//  HostingController.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 14.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<Login> {
    override var body: Login {
        return Login()
    }
}
