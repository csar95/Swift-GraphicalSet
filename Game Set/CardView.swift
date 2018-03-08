//
//  CardView.swift
//  Game Set
//
//  Created by Cesar Gutierrez Carrero on 7/3/18.
//  Copyright © 2018 Cesar Gutierrez Carrero. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    
    var card : Card! {
        didSet {
            draw(frame)
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * cornerRadiusCoefficient)
        UIColor.white.setFill()
        roundedRect.fill()
        
        if (card.isSelected) {
            UIColor.yellow.setStroke()
            roundedRect.lineWidth = 5
            roundedRect.stroke()
        }
        if (card.formASet) {
            UIColor.red.setStroke()
            roundedRect.lineWidth = 5
            roundedRect.stroke()
        }
        
        let cornerOffSet = (rect.height * cornerRadiusCoefficient) * cornerOffsetCoefficient
        let boxRect = rect.insetBy(dx: cornerOffSet, dy: cornerOffSet)
        
        drawShapes(in: boxRect, repeat: card.times, shape: card.shape, with: card.color, shade: card.shade)
    }
    
    private func drawShapes(in boxRect: CGRect, repeat times: Numbers, shape: Shapes, with color: Colors, shade: Shading)
    {
        switch times {
        case .one:
            let (_, auxRect) = boxRect.divided(atDistance: boxRect.height/3, from: .minYEdge)
            let (middleRect, _) = auxRect.divided(atDistance: auxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: middleRect, with: color, shade: shade) }
            else if (shape == .diamond) { drawDiamond(within: middleRect, with: color, shade: shade) }
            else { drawSquiggle(within: middleRect, with: color, shade: shade) }
            
            break
        case .two:
            let (upperRect, auxRect) = boxRect.divided(atDistance: boxRect.height/3, from: .minYEdge)
            let (_, lowerRect) = auxRect.divided(atDistance: auxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: upperRect, with: color, shade: shade); drawOval(within: lowerRect, with: color, shade: shade) }
            else if (shape == .diamond) { drawDiamond(within: upperRect, with: color, shade: shade); drawDiamond(within: lowerRect, with: color, shade: shade) }
            else { drawSquiggle(within: upperRect, with: color, shade: shade); drawSquiggle(within: lowerRect, with: color, shade: shade) }
            
            break
        case .three:
            let (upperRect, auxRect) = boxRect.divided(atDistance: boxRect.height/3, from: .minYEdge)
            let (middleRect, lowerRect) = auxRect.divided(atDistance: auxRect.height/2, from: .minYEdge)
            
            if (shape == .oval) { drawOval(within: upperRect, with: color, shade: shade); drawOval(within: middleRect, with: color, shade: shade); drawOval(within: lowerRect, with: color, shade: shade) }
            else if (shape == .diamond) { drawDiamond(within: upperRect, with: color, shade: shade); drawDiamond(within: middleRect, with: color, shade: shade); drawDiamond(within: lowerRect, with: color, shade: shade) }
            else { drawSquiggle(within: upperRect, with: color, shade: shade); drawSquiggle(within: middleRect, with: color, shade: shade); drawSquiggle(within: lowerRect, with: color, shade: shade) }
            
            break
        }
    }
    
}



extension CardView {
    private var cornerRadiusCoefficient: CGFloat { return 0.1 }
    private var cornerOffsetCoefficient: CGFloat { return 0.33 }
    
    private func drawOval(within rect: CGRect, with color: Colors, shade: Shading) {
        let cornerOffSetX = rect.width * cornerOffsetCoefficient
        let cornerOffSetY = rect.height * cornerOffsetCoefficient
        let ovalRect = rect.insetBy(dx: cornerOffSetX/2, dy: cornerOffSetY/1.5)
        
        let oval = UIBezierPath(ovalIn: ovalRect)
        
        drawInside(of: oval, within: rect, with: color, shade: shade)
    }
    
    private func drawDiamond(within rect: CGRect, with color: Colors, shade: Shading) {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint( x: rect.midX, y: rect.midY + (rect.height/3) ))
        diamond.addLine(to: CGPoint( x: rect.midX + (rect.width/3), y: rect.midY ))
        diamond.addLine(to: CGPoint( x: rect.midX, y: rect.midY - (rect.height/3) ))
        diamond.addLine(to: CGPoint( x: rect.midX - (rect.width/3), y: rect.midY ))
        diamond.close()
        
        drawInside(of: diamond, within: rect, with: color, shade: shade)
    }
    
    private func drawSquiggle(within rect: CGRect, with color: Colors, shade: Shading) {
        let squiggle = UIBezierPath()
        squiggle.addArc(withCenter: CGPoint(x: rect.midX - (rect.width/2)/6, y: rect.midY), radius: (rect.width/2)/6, startAngle: 0, endAngle: 3*CGFloat.pi/2, clockwise: false)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY - (rect.width/2)/6), radius: (rect.width/2)/6, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: true)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX + (rect.width/2)/6, y: rect.midY), radius: (rect.width/2)/6, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: false)
        squiggle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY + (rect.width/2)/6), radius: (rect.width/2)/6, startAngle: 0, endAngle: 3*CGFloat.pi/2, clockwise: true)
        squiggle.close()
        
        drawInside(of: squiggle, within: rect, with: color, shade: shade)
    }
    
    private func drawInside(of path: UIBezierPath, within rect: CGRect, with color: Colors, shade: Shading) {
        if (shade == Shading.open) {
            switch color {
            case .green:
                UIColor.green.setStroke()
            case .red:
                UIColor.red.setStroke()
            case .purple:
                UIColor.purple.setStroke()
            }
            path.stroke()
        }
        else if (shade == Shading.solid) {
            switch color {
            case .green:
                UIColor.green.setFill()
            case .red:
                UIColor.red.setFill()
            case .purple:
                UIColor.purple.setFill()
            }
            path.fill()
        }
        else {
            // Saves the entire graphics state (including the clipping) at the time you call it
            UIGraphicsGetCurrentContext()?.saveGState()
            path.addClip()
            switch color {
            case .green:
                UIColor.green.setStroke()
            case .red:
                UIColor.red.setStroke()
            case .purple:
                UIColor.purple.setStroke()
            }
            drawStripes(in: rect)
            path.stroke()
            // Returns back to that saved graphics state
            UIGraphicsGetCurrentContext()?.restoreGState()
        }
    }
    
    private func drawStripes(in rect: CGRect) {
        let numberOfStripes = 15
        let path = UIBezierPath()
        
        let step = Int(rect.width)/numberOfStripes
        
        for stripe in 1...numberOfStripes {
            path.move(to: CGPoint(x: rect.minX + CGFloat(step*stripe), y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + CGFloat(step*stripe), y: rect.maxY))
        }
        path.stroke()
    }
}
