//
//  PurchasesStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 20.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Combine
import SPAlert
import Purchases

class PurchasesStore: ObservableObject {
    
    @Published var purchasesInfo: Purchases.PurchaserInfo?
    @Published var purchasesSameDay: Bool = false
    @Published var annualPrice: String = ""
    @Published var monthlyPrice: String = ""
    
    static let shared = PurchasesStore()
    
    var offering: Purchases.Offering?
    
    func fetchProduct() {
        Purchases.shared.offerings { offerings, error in
            if let error = error {
                print(error.localizedDescription)
            }
            self.offering = offerings?.current
            for package in self.offering!.availablePackages {
                let packageAnnualPrice = self.offering?.annual
                self.annualPrice = packageAnnualPrice!.localizedPriceString
                let packageMonthlyPrice = self.offering?.monthly
                self.monthlyPrice = packageMonthlyPrice!.localizedPriceString
                print("Продукт: \(package.product.localizedDescription), цена: \(package.localizedPriceString)")
            }
        }
    }
    
    func listenPurchases() {
        Purchases.shared.purchaserInfo { purchaserInfo, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.purchasesInfo = purchaserInfo
                self.purchasesIsDateInToday()
                print("Смотрим подписки!")
            }
        }
    }
    
    func buySubscription(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { transaction, purchaserInfo, error, userCancelled in
            if purchaserInfo?.entitlements.active.first != nil {
                if let error = error {
                    if userCancelled == true {
                        print("Отменено пользователем!")
                    } else {
                        SPAlert.present(title: "Произошла ошибка!", message: "Повторите попытку через несколько минут.", preset: .error)
                        print(error.localizedDescription)
                    }
                } else {
                    Purchases.shared.purchaserInfo { purchaserInfo, error in
                        if let error = error {
                            SPAlert.present(title: "Произошла ошибка!", message: "Повторите попытку через несколько минут.", preset: .error)
                            print(error.localizedDescription)
                        } else {
                            self.purchasesInfo = purchaserInfo
                            self.purchasesIsDateInToday()
                            SPAlert.present(title: "Подписка оформлена!", message: "Вы очень помогаете развитию приложения!", preset: .heart)
                        }
                    }
                }
            }
        }
    }
    
    func restoreSubscription() {
        Purchases.shared.restoreTransactions { purchaserInfo, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let purchaserInfo = purchaserInfo {
                    if purchaserInfo.entitlements.active.isEmpty {
                        print("Restore Unsuccessful")
                        SPAlert.present(title: "Подписка не найдена!", message: "Если вы уверены, что у вас есть действующая подписка, напишите на почту me@lisindmitriy.me.", preset: .error)
                    } else {
                        Purchases.shared.purchaserInfo { purchaserInfo, error in
                            if let error = error {
                                SPAlert.present(title: "Подписка не найдена!", message: "Если вы уверены, что у вас есть действующая подписка, напишите на почту me@lisindmitriy.me.", preset: .error)
                                print(error.localizedDescription)
                            } else {
                                self.purchasesInfo = purchaserInfo
                                SPAlert.present(title: "Подписка восстановлена!", message: "Премиум функции активированы.", preset: .heart)
                                self.purchasesIsDateInToday()
                                print("Обновляем подписки!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func purchasesIsDateInToday() {
        if !purchasesInfo!.activeSubscriptions.isEmpty {
            let isToday = Calendar.current.isDateInToday(purchasesInfo!.expirationDate(forEntitlement: "altgtu")!)
            purchasesSameDay = isToday
            print("Подписка продлиться сегодня: \(purchasesSameDay)")
        }
    }
}
