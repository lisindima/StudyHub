//
//  SubscriptionWatchView.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 26.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Espera
import Purchases

struct SubscriptionWatchView: View {
    
    @ObservedObject var purchasesStore: PurchasesStore = PurchasesStore.shared
    
    var body: some View {
        VStack {
            if purchasesStore.monthlyPrice == "" {
                LoadingFlowerView()
                    .onAppear(perform: purchasesStore.fetchProduct)
            } else {
                Button(action: {
                    self.purchasesStore.buySubscription(package: (self.purchasesStore.offering?.monthly)!)
                }) {
                    Text("\(purchasesStore.monthlyPrice) / в месяц.")
                }
                Button(action: {
                    self.purchasesStore.buySubscription(package: (self.purchasesStore.offering?.annual)!)
                }) {
                    Text("\(purchasesStore.annualPrice) / в год.")
                }
            }
        }.navigationBarTitle(Text("Подписки"))
    }
}

struct SubscriptionWatchView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionWatchView()
    }
}
