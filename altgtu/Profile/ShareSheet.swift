//
//  ShareSheet.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 17.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController

    var sharing: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: sharing, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {

    }
}
