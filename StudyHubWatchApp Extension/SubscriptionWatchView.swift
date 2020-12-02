//
//  SubscriptionWatchView.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 26.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Purchases
import SwiftUI

struct SubscriptionWatchView: View {
    @ObservedObject private var purchasesStore = PurchasesStore.shared

    var body: some View {
        VStack {
            if purchasesStore.monthlyPrice == "" {
                ProgressView()
                    .onAppear(perform: purchasesStore.fetchProduct)
            } else {
                Button(action: {
                    purchasesStore.buySubscription(package: purchasesStore.offering!.monthly!)
                }) {
                    Text("\(purchasesStore.monthlyPrice) / в месяц.")
                }
                Button(action: {
                    purchasesStore.buySubscription(package: purchasesStore.offering!.annual!)
                }) {
                    Text("\(purchasesStore.annualPrice) / в год.")
                }
            }
        }.navigationBarTitle("Подписки")
    }
}

struct SubscriptionWatchView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionWatchView()
    }
}
