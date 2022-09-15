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
        
        var positionX: CGFloat = 0
        var positionY: CGFloat = 0
        
        switch locationCollection.x {
        case ...CGFloat(view.frame.width / 2):
            positionX = locationView.x
        case CGFloat(view.frame.width / 2) + 1...mainView.bounds.width - view.frame.width / 2:
            positionX = locationView.x - view.frame.width / 2
        default:
            positionX = locationView.x - view.frame.width
        }
        
        switch locationCollection.y {
        case ...view.frame.height: positionY = locationView.y + 20
        default: positionY = locationView.y - view.bounds.height - 20
        }
        
        return CGPoint(x: positionX, y: positionY)
    }
    
}
