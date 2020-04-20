//
//  RichLink.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 20.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import LinkPresentation

struct RichLink: UIViewRepresentable {
    
    var url: URL
    
    func makeUIView(context: Context) -> LPLinkView {
        
        let linkView = LPLinkView(url: url)
        let dataProvider = LPMetadataProvider()
        
        dataProvider.startFetchingMetadata(for: url) { metaData, error in
            if let metaData = metaData {
                DispatchQueue.main.async {
                    linkView.metadata = metaData
                    linkView.sizeToFit()
                }
            }
        }
        return linkView
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
        
    }
}
