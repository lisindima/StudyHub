//
//  PencilKitCanvas.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import PencilKit

struct PencilKitCanvas: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.tool = PKInkingTool(.pen, color: .red, width: 10)
        return canvas
    }
        
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
            
    }
}
