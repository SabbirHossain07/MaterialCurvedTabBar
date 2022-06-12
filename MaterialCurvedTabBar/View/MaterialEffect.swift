//
//  MaterialEffect.swift
//  MaterialCurvedTabBar
//
//  Created by Sopnil Sohan on 12/6/22.
//

import SwiftUI

struct MaterialEffect: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
