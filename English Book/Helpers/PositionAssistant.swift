//
//  PositionAssistant.swift
//  English Book
//
//  Created by mac on 05.08.2022.
//

import UIKit

class PositionAssistant {
    static let shared = PositionAssistant()
    
    private init() {}
    
    func setPosition(_ view: UIView, _ locationCollection: CGPoint, _ locationView: CGPoint, _ mainView: UIView) -> CGPoint {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        switch locationCollection.x {
        case ...CGFloat(view.frame.width / 2):
            x = locationView.x
        case CGFloat(view.frame.width / 2) + 1...mainView.bounds.width - view.frame.width / 2:
            x = locationView.x - view.frame.width / 2
        default:
            x = locationView.x - view.frame.width
        }
        
        switch locationCollection.y {
        case ...view.frame.height:  y = locationView.y + 20
        default: y = locationView.y - view.bounds.height - 20
        }
        
        return CGPoint(x: x, y: y)
    }
    
}
