//
//  SubscriptionWatchView.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 26.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Purchases

struct SubscriptionWatchView: View {
    
    @ObservedObject var purchasesStore: PurchasesStore = PurchasesStore.shared
    
    var body: some View {
        ScrollView {
            Text(purchasesStore.monthlyPrice)
                .fontWeight(.bold)
            Button(action: {
                self.purchasesStore.buySubscription(package: (self.purchasesStore.offering?.monthly)!)
                self.purchasesStore.loadingMonthlyButton = true
            }) {
                Text("Ежемесячно")
            }
            Text(purchasesStore.annualPrice)
                .fontWeight(.bold)
            Button(action: {
                self.purchasesStore.buySubscription(package: (self.purchasesStore.offering?.annual)!)
                self.purchasesStore.loadingAnnualButton = true
            }) {
                Text("Ежегодно")
            }
        }
        .navigationBarTitle(Text("Подписки"))
        .onAppear(perform: purchasesStore.fetchProduct)
    }
}

struct SubscriptionWatchView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionWatchView()
    }
}
