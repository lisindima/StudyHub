//
//  NFCStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import CoreNFC

class NFCStore: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    
    var readerSession: NFCTagReaderSession?

    func readCard() {
        readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        readerSession?.alertMessage = "Приложите свой пропуск для сканирования."
        readerSession?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {

    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if case let NFCTag.iso7816(tag) = tags.first! {
            
            session.connect(to: tags.first!) { (error: Error?) in
                
                let myAPDU = NFCISO7816APDU(instructionClass:0, instructionCode:0xB0, p1Parameter:0, p2Parameter:0, data: Data(), expectedResponseLength:16)
                tag.sendCommand(apdu: myAPDU) { (response: Data, sw1: UInt8, sw2: UInt8, error: Error?)
                    in
                    
                    guard error != nil && !(sw1 == 0x90 && sw2 == 0) else {
                        session.invalidate(errorMessage: "Application failure")
                        return
                    }
                }
            }
        }
    }
}
