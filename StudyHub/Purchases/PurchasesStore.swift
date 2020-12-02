//
//  PurchasesStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 20.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Combine
import Purchases
#if os(iOS)
    import SPAlert
#endif

class PurchasesStore: ObservableObject {
    @Published var purchasesInfo: Purchases.PurchaserInfo?
    @Published var purchasesSameDay: Bool = false
    @Published var loadingMonthlyButton: Bool = false
    @Published var loadingAnnualButton: Bool = false
    @Published var annualPrice: String = ""
    @Published var monthlyPrice: String = ""

    static let shared = PurchasesStore()

    var offering: Purchases.Offering?

    func fetchProduct() {
        Purchases.shared.offerings { [self] offerings, error in
            if let error = error {
                #if os(iOS)
                    SPAlert.present(title: "Произошла ошибка!", message: "Повторите попытку через несколько минут.", preset: .error)
                #endif
                print(error.localizedDescription)
            }
            guard let currentOffering = offerings?.current else {
                #if os(iOS)
                    SPAlert.present(title: "Произошла ошибка!", message: "Повторите попытку через несколько минут.", preset: .error)
                #endif
                print("No current offering configured")
                return
            }
            offering = currentOffering
            for package in currentOffering.availablePackages {
                let packageAnnualPrice = currentOffering.annual
                annualPrice = packageAnnualPrice!.localizedPriceString
                let packageMonthlyPrice = currentOffering.monthly
                monthlyPrice = packageMonthlyPrice!.localizedPriceString
                print("Продукт: \(package.product.localizedDescription), цена: \(package.localizedPriceString)")
            }
        }
    }

    func listenPurchases() {
        Purchases.shared.purchaserInfo { [self] info, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                purchasesInfo = info
                purchasesIsDateInToday()
            }
        }
    }

    func buySubscription(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { [self] _, purchaserInfo, error, userCancelled in
            if userCancelled {
                loadingMonthlyButton = false
                loadingAnnualButton = false
                print("Отменено пользователем!")
                return
            }
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                loadingMonthlyButton = false
                loadingAnnualButton = false
                #if os(iOS)
                    SPAlert.present(title: "Произошла ошибка!", message: "Повторите попытку через несколько минут.", preset: .error)
                #endif
            } else if purchaserInfo?.entitlements.active != nil {
                loadingMonthlyButton = false
                loadingAnnualButton = false
                #if os(iOS)
                    SPAlert.present(title: "Подписка оформлена!", message: "Вы очень помогаете развитию приложения!", preset: .heart)
                #endif
            }
        }
    }

    func restoreSubscription() {
        Purchases.shared.restoreTransactions { _, error in
            if error != nil {
                #if os(iOS)
                    SPAlert.present(title: "Подписка не найдена!", message: "Если вы уверены, что у вас есть действующая подписка, напишите на почту me@lisindmitriy.me.", preset: .error)
                #endif
            } else {
                #if os(iOS)
                    SPAlert.present(title: "Подписка восстановлена!", message: "Премиум функции активированы.", preset: .heart)
                #endif
            }
        }
    }

    func purchasesIsDateInToday() {
        if !purchasesInfo!.activeSubscriptions.isEmpty {
            let isToday = Calendar.current.isDateInToday(purchasesInfo!.expirationDate(forEntitlement: "altgtu")!)
            purchasesSameDay = isToday
        }
    }
}
