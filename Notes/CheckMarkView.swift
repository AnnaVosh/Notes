//
//  ColorSquareView.swift
//  Notes
//
//  Created by Анна Коптева on 09/07/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CheckMarkView: UIView{
    @IBInspectable var shapeColor: UIColor = .black{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = CGPoint(x: 40, y: 5){
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeSize: CGSize = CGSize(width: 15, height: 15){
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden: Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard isShapeHidden else {return}
        getCheckMarkPath(in: CGRect(origin: shapePosition, size: shapeSize))
    }
    
    private func getCheckMarkPath(in rect: CGRect) {
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX,y: rect.midY), radius: CGFloat(rect.width/2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        path.lineWidth = 2
        path.move(to: CGPoint(x: rect.minX+4, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY-4))
        path.addLine(to: CGPoint(x: rect.midX + rect.width/4, y: rect.minY + rect.height/4))
        path.stroke()
    }
}
