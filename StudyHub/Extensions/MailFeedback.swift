//
//  MailFeedback.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 15.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import MessageUI
import SPAlert
import SwiftUI

struct MailFeedback: UIViewControllerRepresentable {
    @Binding var mailSubject: String

    let dataEmail = Data("Привет".utf8)

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailFeedback>) -> MFMailComposeViewController {
        let mailFeedback = MFMailComposeViewController()
        mailFeedback.setToRecipients(["me@lisindmitriy.me"])
        mailFeedback.addAttachmentData(dataEmail, mimeType: "text/plain", fileName: "log.txt")
        mailFeedback.setSubject(mailSubject)
        mailFeedback.setMessageBody("<p>Привет!</p>", isHTML: true)
        mailFeedback.mailComposeDelegate = context.coordinator
        return mailFeedback
    }

    func updateUIViewController(_: MFMailComposeViewController, context _: UIViewControllerRepresentableContext<MailFeedback>) {}

    func makeCoordinator() -> MailFeedback.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailFeedback

        init(_ parent: MailFeedback) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error _: Error?) {
            controller.dismiss(animated: true, completion: nil)
            switch result {
            case .sent:
                SPAlert.present(title: "Сообщение отправлено!", message: "Я отвечу на него в ближайшее время.", preset: .heart)
            case .saved:
                SPAlert.present(title: "Сообщение сохранено!", message: "Сообщение ждет вас в черновиках.", preset: .done)
            case .failed:
                SPAlert.present(title: "Ошибка!", message: "Повторите попытку позже", preset: .error)
            case .cancelled:
                print("Отменено пользователем")
            @unknown default:
                print("Отправка почты: ошибка")
            }
        }
    }
}
