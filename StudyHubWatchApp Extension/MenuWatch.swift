//
//  MenuWatch.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 16.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct MenuWatch: View {
    @ObservedObject private var sessionStoreWatch = SessionStoreWatch.shared
    @ObservedObject private var purchasesStore = PurchasesStore.shared
    @ObservedObject private var dateStore = DateStore.shared

    var body: some View {
        VStack {
            NavigationLink(destination: ScheduleListWatch()) {
                Text("Расписание")
            }
            if purchasesStore.purchasesInfo!.activeSubscriptions.isEmpty {
                NavigationLink(destination: SubscriptionWatchView()) {
                    Text("Подписки")
                }
            } else {
                if purchasesStore.purchasesSameDay {
                    Text("Подписка продлится: Сегодня, \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: dateStore.dateHour)")
                } else {
                    Text("Подписка продлится: \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: dateStore.dateDay)")
                }
            }
            Divider()
            Button("Выйти") {
                sessionStoreWatch.signInSuccess = false
            }
        }.navigationBarTitle("Главная")
    }
}
