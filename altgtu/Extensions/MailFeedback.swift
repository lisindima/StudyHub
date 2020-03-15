//
//  MailFeedback.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 15.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import MessageUI

struct MailFeedback: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailFeedback>) -> MFMailComposeViewController {
        let mailFeedback = MFMailComposeViewController()
        mailFeedback.setToRecipients(["me@lisindmitriy.me"])
        mailFeedback.setSubject("Запрос функций")
        mailFeedback.setMessageBody("<p>Привет!</p>", isHTML: true)
        mailFeedback.mailComposeDelegate = context.coordinator
        return mailFeedback
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailFeedback>) {
        
    }
    
    func makeCoordinator() -> MailFeedback.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailFeedback
        
        init(_ parent: MailFeedback) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
