//
//  ColorPointerView.swift
//  Notes
//
//  Created by Анна Коптева on 11/07/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ColorPointerView: UIView{
    @IBInspectable var shapeColor: UIColor = .black{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = .zero{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeRadius: CGFloat = 5{
        didSet{
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        getPickerPath(in: CGPoint(x: shapePosition.x, y: shapePosition.y), with: shapeRadius)
    }
    
    func getPickerPath(in center: CGPoint, with radius: CGFloat) {
        let path = UIBezierPath(arcCenter: CGPoint(x: center.x, y: center.y), radius: radius, startAngle: CGFloat(), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        path.lineWidth = 2
        path.stroke()
    }
}

