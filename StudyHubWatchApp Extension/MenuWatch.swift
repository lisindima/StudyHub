//
//  MenuWatch.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 16.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct MenuWatch: View {
    
    @ObservedObject var purchasesStore: PurchasesStore = PurchasesStore.shared
    @ObservedObject var dateStore: DateStore = DateStore.shared
    
    @Binding var signInSuccess: Bool
    
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
                self.signInSuccess = false
            }
        }.navigationBarTitle(Text("Главная"))
    }
}
