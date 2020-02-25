//
//  PurchasesStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 20.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Purchases

class PurchasesStore: ObservableObject {
    
    @Published var purchasesInfo: Purchases.PurchaserInfo?
    @Published var subscribeExpirationDate: String = ""
    @Published var subscribeExpirationDateHour: String = ""
    
    static let shared = PurchasesStore()
    
    let stringPurchasesDate: String = {
        var currentDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        let createStringDate = dateFormatter.string(from: currentDate)
        return createStringDate
    }()
    
    func listenPurchases() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.purchasesInfo = purchaserInfo
                self.getSubscriptionsExpirationDate()
                print("Смотрим подписки!")
            }
        }
    }
    
    func getSubscriptionsExpirationDate() {
        if !purchasesInfo!.activeSubscriptions.isEmpty {
            subscribeExpirationDate = {
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
                let createStringDate = dateFormatter.string(from: purchasesInfo!.expirationDate(forEntitlement: "altgtu")!)
                return createStringDate
            }()
            if stringPurchasesDate == subscribeExpirationDate {
                subscribeExpirationDateHour = {
                    let dateFormatter = DateFormatter()
                    dateFormatter.setLocalizedDateFormatFromTemplate("HH-mm")
                    let createStringDate = dateFormatter.string(from: purchasesInfo!.expirationDate(forEntitlement: "altgtu")!)
                    return createStringDate
                }()
            }
        }
    }
}
