//
//  TodayViewController.swift
//  altgtuTodayWidget
//
//  Created by Дмитрий Лисин on 11.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import NotificationCenter

class TodayViewController: UIHostingController<TodayWidgetView>, NCWidgetProviding {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: TodayWidgetView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
