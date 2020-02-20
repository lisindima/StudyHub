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
    
    static let shared = PurchasesStore()
    
    func listenPurchases() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.purchasesInfo = purchaserInfo
                print("Смотрим подписки!")
            }
        }
    }
}
