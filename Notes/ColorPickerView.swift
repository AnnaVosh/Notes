//
//  ColorPickerView.swift
//  Notes
//
//  Created by Анна Коптева on 10/07/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//
import UIKit


@IBDesignable
class ColorPickerView : UIView {
    
    var onColorDidChange: ((_ color: UIColor) -> ())?
    
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3
    
    @IBInspectable var rect_mainPalette = CGRect.zero
    
    var colorPointer: ColorPointerView = ColorPointerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var currentColor: UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
        
        //add subview with Pointer
        colorPointer = ColorPointerView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width*2.5, height: self.frame.size.height))
        colorPointer.backgroundColor = UIColor(white: 1, alpha: 0)
        self.addSubview(colorPointer)
    }
    
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        rect_mainPalette = CGRect(x: 0, y: 0,
                                  width: rect.width, height: rect.height)
        
        for y in stride(from: CGFloat(0), to: rect_mainPalette.height, by: elementSize) {
            
            var saturation = y < rect_mainPalette.height / 2.0 ? CGFloat(2 * y) / rect_mainPalette.height : 2.0 * CGFloat(rect_mainPalette.height - y) / rect_mainPalette.height
            saturation = CGFloat(powf(Float(saturation), y < rect_mainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect_mainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect_mainPalette.height - y) / rect_mainPalette.height
            
            for x in stride(from: (0 as CGFloat), to: rect_mainPalette.width, by: elementSize) {
                let hue = x / rect_mainPalette.width
                
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y: y + rect_mainPalette.origin.y,
                                     width: elementSize, height: elementSize))
            }
        }
    }
    
    
    
    func getColorAtPoint(point: CGPoint) -> UIColor
    {
        var roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        
        let hue = roundedPoint.x / self.bounds.width
        
            roundedPoint.y -= rect_mainPalette.origin.y
            
            var saturation = roundedPoint.y < rect_mainPalette.height / 2.0 ? CGFloat(2 * roundedPoint.y) / rect_mainPalette.height
                : 2.0 * CGFloat(rect_mainPalette.height - roundedPoint.y) / rect_mainPalette.height
            
            saturation = CGFloat(powf(Float(saturation), roundedPoint.y < rect_mainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = roundedPoint.y < rect_mainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect_mainPalette.height - roundedPoint.y) / rect_mainPalette.height
            
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func moveColorPointer(to point: CGPoint){
        colorPointer.shapePosition = point
        print(colorPointer.shapePosition)
    }
    
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        currentColor = getColorAtPoint(point: point)
        moveColorPointer(to: point)
        self.onColorDidChange?(currentColor)
    }
}
