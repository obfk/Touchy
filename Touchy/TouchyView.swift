//
//  TouchyView.swift
//  Touchy
//
//  Created by Devin Brown on 6/13/15.
//  Copyright (c) 2015 Apress. All rights reserved.
//

import UIKit

class TouchyView: UIView {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        updateTouches(event.allTouches())
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        updateTouches(event.allTouches())
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        updateTouches(event.allTouches())
    }

    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        updateTouches(event.allTouches())
    }

    var touchPoints = [CGPoint]()

    func updateTouches( touches: NSSet? ) {
        touchPoints = []

        touches?.enumerateObjectsUsingBlock() { (element, stop) in
            if let touch = element as? UITouch {
                switch touch.phase {
                    case .Began, .Moved, .Stationary:
                        self.touchPoints.append(touch.locationInView(self))
                    default:
                        break
                }
            }
        }

        setNeedsDisplay()

    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIColor.blackColor().set()
        CGContextFillRect(context, rect)

        var connectionPath: UIBezierPath?
        if touchPoints.count > 1 {
            for location in touchPoints {
                if let path = connectionPath {
                    path.addLineToPoint(location)
                }
                else {
                    connectionPath = UIBezierPath()
                    connectionPath!.moveToPoint(location)
                }
            }
            if touchPoints.count > 2 {
                connectionPath!.closePath()
            }
        }

        if let path = connectionPath {
            UIColor.lightGrayColor().set()
            path.lineWidth = 6
            path.lineCapStyle = kCGLineCapRound
            path.lineJoinStyle = kCGLineJoinRound
            path.stroke()
        }

        var touchNumber = 0
        let fontAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(180),
            NSForegroundColorAttributeName: UIColor.yellowColor()
        ];

        for location in touchPoints {
            let text: NSString = "\(++touchNumber)"
            let size = text.sizeWithAttributes(fontAttributes)
            let textCorner = CGPoint(x: location.x-size.width / 2, y: location.y-size.height / 2)
            text.drawAtPoint(textCorner, withAttributes: fontAttributes)
        }
    }
}
